//! # Plugin AST Traversal Helpers
//!
//! Shared AST matching and block analysis utilities used across extractor plugins.

use full_moon::ast::{
    BinOp, Block, Expression, FunctionBody, Prefix, Stmt, Suffix, UnOp, Var,
};
use indexmap::IndexMap;

use crate::infer::InferenceEngine;
use crate::model::FieldDef;

pub fn match_ident_name(expr: &Expression) -> Option<String> {
    if let Expression::Var(Var::Name(tok)) = expr {
        return Some(tok.token().to_string().trim().to_string());
    }
    None
}

pub fn match_function_body(expr: &Expression) -> Option<&FunctionBody> {
    if let Expression::Function(anon_fn) = expr {
        return Some(anon_fn.body());
    }
    None
}

/// Checks if an expression matches an identifier with the given name
fn expr_is_name(expr: &Expression, target: &str) -> bool {
    match expr {
        Expression::Var(Var::Name(tok)) => tok.token().to_string().trim() == target,
        Expression::Parentheses { expression, .. } => expr_is_name(expression, target),
        _ => false,
    }
}

/// Checks if an expression is `nil`
fn expr_is_nil(expr: &Expression) -> bool {
    match expr {
        Expression::Symbol(tok) => tok.token().to_string().trim() == "nil",
        Expression::Parentheses { expression, .. } => expr_is_nil(expression),
        _ => false,
    }
}

/// Recursively checks if an expression tests whether `param_name` is nil/truthy or has a fallback:
/// - `param_name` (e.g. `if param then`)
/// - `not param_name` (e.g. `if not param then`)
/// - `param_name == nil` / `param_name ~= nil` / `nil == param_name` / `nil ~= param_name`
/// - `param_name or ...`
pub fn expr_checks_param_optionality(expr: &Expression, param_name: &str) -> bool {
    if expr_is_name(expr, param_name) {
        return true;
    }
    match expr {
        Expression::Parentheses { expression, .. } => {
            expr_checks_param_optionality(expression, param_name)
        }
        Expression::UnaryOperator {
            unop: UnOp::Not(_),
            expression,
        } => expr_checks_param_optionality(expression, param_name),
        Expression::BinaryOperator { lhs, binop, rhs } => match binop {
            BinOp::Or(_) => {
                expr_checks_param_optionality(lhs, param_name)
                    || expr_checks_param_optionality(rhs, param_name)
            }
            BinOp::And(_) => {
                expr_checks_param_optionality(lhs, param_name)
                    || expr_checks_param_optionality(rhs, param_name)
            }
            BinOp::TwoEqual(_) | BinOp::TildeEqual(_) => {
                (expr_is_name(lhs, param_name) && expr_is_nil(rhs))
                    || (expr_is_name(rhs, param_name) && expr_is_nil(lhs))
            }
            _ => false,
        },
        _ => false,
    }
}

/// Scans a block to see if `param_name` is treated as optional:
/// - Assigned with `param = param or <default>`
/// - Tested in an `if` condition: `if not param`, `if param == nil`, `if param ~= nil`, `if param`
/// - Tested in `elseif` condition
pub fn is_param_optional_in_block(block: &Block, param_name: &str) -> bool {
    for stmt in block.stmts() {
        match stmt {
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    if let Var::Name(tok) = var
                        && tok.token().to_string().trim() == param_name
                        && expr_checks_param_optionality(expr, param_name)
                    {
                        return true;
                    }
                }
            }
            Stmt::LocalAssignment(local_assign) => {
                for expr in local_assign.expressions() {
                    if expr_checks_param_optionality(expr, param_name) {
                        return true;
                    }
                }
            }
            Stmt::If(if_stmt) => {
                if expr_checks_param_optionality(if_stmt.condition(), param_name) {
                    return true;
                }
                if let Some(else_ifs) = if_stmt.else_if() {
                    for else_if in else_ifs {
                        if expr_checks_param_optionality(else_if.condition(), param_name) {
                            return true;
                        }
                    }
                }
                if is_param_optional_in_block(if_stmt.block(), param_name) {
                    return true;
                }
                if let Some(else_ifs) = if_stmt.else_if() {
                    for else_if in else_ifs {
                        if is_param_optional_in_block(else_if.block(), param_name) {
                            return true;
                        }
                    }
                }
                if let Some(else_block) = if_stmt.else_block()
                    && is_param_optional_in_block(else_block, param_name)
                {
                    return true;
                }
            }
            Stmt::Do(do_stmt) => {
                if is_param_optional_in_block(do_stmt.block(), param_name) {
                    return true;
                }
            }
            _ => {}
        }
    }
    false
}

pub fn collect_block_fields_and_locals(
    block: &Block,
    fields: &mut IndexMap<String, FieldDef>,
    locals: &mut IndexMap<String, String>,
    requires: &IndexMap<String, String>,
    infer: &InferenceEngine,
) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::LocalAssignment(local_assign) => {
                for (name_tok, expr) in local_assign
                    .names()
                    .iter()
                    .zip(local_assign.expressions().iter())
                {
                    let lname = name_tok.token().to_string().trim().to_string();
                    let ty = infer.infer_expr_type(expr, requires, locals);
                    locals.insert(lname, ty);
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    match var {
                        Var::Name(tok) => {
                            let name = tok.token().to_string().trim().to_string();
                            let ty = infer.infer_expr_type(expr, requires, locals);
                            locals.insert(name, ty);
                        }
                        Var::Expression(var_expr) => {
                            // Check if this is `self.<field> = <expr>`
                            if let Prefix::Name(tok) = var_expr.prefix()
                                && tok.token().to_string().trim() == "self"
                            {
                                let suffixes: Vec<_> = var_expr.suffixes().collect();
                                if suffixes.len() == 1
                                    && let Suffix::Index(full_moon::ast::Index::Dot {
                                        name, ..
                                    }) = &suffixes[0]
                                {
                                    let field_name = name.token().to_string().trim().to_string();
                                    let ty = infer.infer_expr_type(expr, requires, locals);
                                    if !fields.contains_key(&field_name) {
                                        fields.insert(
                                            field_name.clone(),
                                            FieldDef {
                                                name: field_name,
                                                ty,
                                                optional: false,
                                            },
                                        );
                                    }
                                }
                            }
                        }
                        _ => {}
                    }
                }
            }
            Stmt::If(if_stmt) => {
                collect_block_fields_and_locals(if_stmt.block(), fields, locals, requires, infer);
                if let Some(else_ifs) = if_stmt.else_if() {
                    for else_if in else_ifs {
                        collect_block_fields_and_locals(
                            else_if.block(),
                            fields,
                            locals,
                            requires,
                            infer,
                        );
                    }
                }
                if let Some(else_block) = if_stmt.else_block() {
                    collect_block_fields_and_locals(else_block, fields, locals, requires, infer);
                }
            }
            Stmt::Do(do_stmt) => {
                collect_block_fields_and_locals(do_stmt.block(), fields, locals, requires, infer);
            }
            _ => {}
        }
    }
}
