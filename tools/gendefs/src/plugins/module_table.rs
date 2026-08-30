//! # Module Table Extractor Plugin
//!
//! ### Purpose
//! Extracts module table patterns where a Lua file declares a local table, attaches functions/methods to it,
//! and returns the table (e.g., `local TEMPLATES = {} ... return TEMPLATES` or `local M = { fn1 = function(...) end } ... return M`).
//!
//! ### Handled Patterns
//! - Table definitions: `local TEMPLATES = {}` or `local TEMPLATES = nil; TEMPLATES = { ... }`
//! - Functions inside table constructor: `local TEMPLATES = { Button = function(...) ... end }`
//! - Dot-method assignments: `function TEMPLATES.Button(...) ... end` or `TEMPLATES.Button = function(...) ... end`
//! - Colon-method assignments: `function TEMPLATES:Method(...) ... end`
//! - Returning the module table: `return TEMPLATES`
//!
//! ### Effect on Unit
//! Adds a [`crate::model::ClassDef`] representing the module namespace without constructor overload,
//! along with all declared methods and fields.

use full_moon::ast::{
    Block, Expression, Field, FunctionBody, LastStmt, Parameter, Prefix, Stmt, Suffix, TableConstructor, Var,
};
use indexmap::IndexMap;

use super::helpers::{
    collect_block_fields_and_locals, is_param_optional_in_block, match_function_body,
};
use crate::model::{ClassDef, FieldDef, MethodDef, ParamDef, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct ModuleTablePlugin;

impl Plugin for ModuleTablePlugin {
    fn name(&self) -> &'static str {
        "module_table"
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        let Some(table_ident) = find_returned_table_ident(ctx.ast.nodes()) else {
            return;
        };

        // If ClassesPlugin or other plugins already created a class with this lua_name, skip
        if unit.classes.iter().any(|c| c.lua_name == table_ident) {
            return;
        }

        let class_name = ctx
            .resolver
            .class_name_for_rel_path(ctx.rel_path, &table_ident);

        let mut class_def = ClassDef {
            lua_name: table_ident.clone(),
            class_name: class_name.clone(),
            base_local: None,
            parent_class_name: None,
            ctor_params: Vec::new(),
            ctor_overloads: Vec::new(),
            fields: IndexMap::new(),
            methods: Vec::new(),
            is_extension: false,
        };

        extract_module_table_members(
            ctx.ast.nodes(),
            &table_ident,
            &mut class_def,
            &unit.requires,
            ctx,
        );

        // Apply field overrides from config if present
        if let Some(class_cfg) = ctx.config.overrides.classes.get(&class_def.class_name) {
            for (fname, fty) in &class_cfg.fields {
                let (clean_ty, opt) = if let Some(stripped) = fty.strip_suffix('?') {
                    (stripped.to_string(), true)
                } else {
                    (fty.clone(), false)
                };
                class_def.fields.insert(
                    fname.clone(),
                    FieldDef {
                        name: fname.clone(),
                        ty: clean_ty,
                        optional: opt,
                    },
                );
            }
        }

        if !class_def.methods.is_empty() || !class_def.fields.is_empty() {
            unit.classes.push(class_def);
        }
    }
}

fn find_returned_table_ident(block: &Block) -> Option<String> {
    if let Some(LastStmt::Return(ret_stmt)) = block.last_stmt() {
        let returns: Vec<_> = ret_stmt.returns().iter().collect();
        if returns.len() == 1
            && let Expression::Var(Var::Name(name_tok)) = returns[0]
        {
            return Some(name_tok.token().to_string().trim().to_string());
        }
    }
    None
}

fn extract_module_table_members(
    block: &Block,
    table_ident: &str,
    class_def: &mut ClassDef,
    requires: &IndexMap<String, String>,
    ctx: &ExtractContext,
) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::LocalAssignment(local_assign) => {
                for (name_tok, expr) in local_assign
                    .names()
                    .iter()
                    .zip(local_assign.expressions().iter())
                {
                    let name = name_tok.token().to_string();
                    if name.trim() == table_ident
                        && let Expression::TableConstructor(tc) = expr
                    {
                        extract_from_table_constructor(tc, class_def, requires, ctx);
                    }
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    match var {
                        Var::Name(name_tok) => {
                            let name = name_tok.token().to_string();
                            if name.trim() == table_ident
                                && let Expression::TableConstructor(tc) = expr
                            {
                                extract_from_table_constructor(tc, class_def, requires, ctx);
                            }
                        }
                        Var::Expression(var_expr) => {
                            if let Prefix::Name(tok) = var_expr.prefix()
                                && tok.token().to_string().trim() == table_ident
                            {
                                let suffixes: Vec<_> = var_expr.suffixes().collect();
                                if suffixes.len() == 1
                                    && let Suffix::Index(full_moon::ast::Index::Dot {
                                        name: member_name_tok,
                                        ..
                                    }) = &suffixes[0]
                                {
                                    let member_name =
                                        member_name_tok.token().to_string().trim().to_string();
                                    if let Some(body) = match_function_body(expr) {
                                        let method = extract_method(
                                            &member_name,
                                            false,
                                            body,
                                            class_def,
                                            requires,
                                            ctx,
                                        );
                                        class_def.methods.push(method);
                                    } else {
                                        let ty = ctx.infer.infer_expr_type(
                                            expr,
                                            requires,
                                            &IndexMap::new(),
                                        );
                                        class_def.fields.insert(
                                            member_name.clone(),
                                            FieldDef {
                                                name: member_name,
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
            Stmt::FunctionDeclaration(func_decl) => {
                let func_name = func_decl.name();
                let names: Vec<_> = func_name.names().iter().collect();
                if names.is_empty() {
                    continue;
                }

                let target_table = names[0].token().to_string();
                if target_table.trim() == table_ident {
                    let is_colon = func_name.method_name().is_some();
                    let method_name = if let Some(m) = func_name.method_name() {
                        m.token().to_string().trim().to_string()
                    } else if names.len() >= 2 {
                        names[1].token().to_string().trim().to_string()
                    } else {
                        continue;
                    };

                    let method = extract_method(
                        &method_name,
                        is_colon,
                        func_decl.body(),
                        class_def,
                        requires,
                        ctx,
                    );
                    class_def.methods.push(method);
                }
            }
            _ => {}
        }
    }
}

fn extract_from_table_constructor(
    tc: &TableConstructor,
    class_def: &mut ClassDef,
    requires: &IndexMap<String, String>,
    ctx: &ExtractContext,
) {
    for field in tc.fields() {
        if let Field::NameKey { key, value, .. } = field {
            let member_name = key.token().to_string().trim().to_string();
            if let Some(body) = match_function_body(value) {
                let method =
                    extract_method(&member_name, false, body, class_def, requires, ctx);
                class_def.methods.push(method);
            } else {
                let ty = ctx.infer.infer_expr_type(value, requires, &IndexMap::new());
                class_def.fields.insert(
                    member_name.clone(),
                    FieldDef {
                        name: member_name,
                        ty,
                        optional: false,
                    },
                );
            }
        }
    }
}

fn extract_method(
    method_name: &str,
    is_colon: bool,
    body: &FunctionBody,
    class_def: &mut ClassDef,
    requires: &IndexMap<String, String>,
    ctx: &ExtractContext,
) -> MethodDef {
    let mut locals = IndexMap::new();
    let mut method_fields = IndexMap::new();
    collect_block_fields_and_locals(
        body.block(),
        &mut method_fields,
        &mut locals,
        requires,
        ctx.infer,
    );

    let mut params = Vec::new();
    for (i, param) in body.parameters().iter().enumerate() {
        // If it's a colon method, the first parameter is implicitly 'self', but Lua AST might not have 'self' in parameter list.
        // If it's dot syntax, all written parameters are included.
        match param {
            Parameter::Name(tok) => {
                let pname = tok.token().to_string().trim().to_string();
                if is_colon && i == 0 && pname == "self" {
                    continue;
                }
                let (ty, optional) = if let Some(overridden) = ctx
                    .infer
                    .infer_method_param_type(&class_def.class_name, method_name, &pname)
                {
                    if let Some(stripped) = overridden.strip_suffix('?') {
                        (stripped.to_string(), true)
                    } else {
                        (overridden, false)
                    }
                } else {
                    let opt = is_param_optional_in_block(body.block(), &pname);
                    let param_ty = ctx.infer.infer_param_type(&pname);
                    if param_ty != "any" {
                        (param_ty, opt)
                    } else if let Some(inferred) = locals.get(&pname).filter(|ty| *ty != "any") {
                        (inferred.clone(), opt)
                    } else {
                        ("any".to_string(), opt)
                    }
                };
                params.push(ParamDef {
                    name: pname,
                    ty,
                    optional,
                });
            }
            Parameter::Ellipsis(_) => {
                params.push(ParamDef {
                    name: "...".to_string(),
                    ty: "any".to_string(),
                    optional: true,
                });
            }
            _ => {}
        }
    }

    let mut returns = Vec::new();
    let mut overloads = Vec::new();

    if let Some(class_cfg) = ctx.config.overrides.classes.get(&class_def.class_name)
        && let Some(method_cfg) = class_cfg.methods.get(method_name)
    {
        if let Some(ret) = &method_cfg.return_type {
            returns.push(ret.clone());
        }
        returns.extend(method_cfg.returns.clone());
        overloads.extend(method_cfg.overloads.clone());
    }

    if returns.is_empty()
        && let Some(inferred_ret) = infer_return_type_from_block(body.block(), &locals, requires, ctx)
    {
        returns.push(inferred_ret);
    }

    MethodDef {
        name: method_name.to_string(),
        is_colon,
        params,
        returns,
        overloads,
    }
}

fn infer_return_type_from_block(
    block: &Block,
    locals: &IndexMap<String, String>,
    requires: &IndexMap<String, String>,
    ctx: &ExtractContext,
) -> Option<String> {
    if let Some(LastStmt::Return(ret_stmt)) = block.last_stmt()
        && let Some(first_expr) = ret_stmt.returns().iter().next()
    {
        let ty = ctx.infer.infer_expr_type(first_expr, requires, locals);
        if ty != "any" {
            return Some(ty);
        }
    }

    for stmt in block.stmts() {
        match stmt {
            Stmt::If(if_stmt) => {
                if let Some(ty) =
                    infer_return_type_from_block(if_stmt.block(), locals, requires, ctx)
                {
                    return Some(ty);
                }
                if let Some(else_ifs) = if_stmt.else_if() {
                    for else_if in else_ifs {
                        if let Some(ty) =
                            infer_return_type_from_block(else_if.block(), locals, requires, ctx)
                        {
                            return Some(ty);
                        }
                    }
                }
                if let Some(else_block) = if_stmt.else_block()
                    && let Some(ty) =
                        infer_return_type_from_block(else_block, locals, requires, ctx)
                {
                    return Some(ty);
                }
            }
            Stmt::Do(do_stmt) => {
                if let Some(ty) =
                    infer_return_type_from_block(do_stmt.block(), locals, requires, ctx)
                {
                    return Some(ty);
                }
            }
            _ => {}
        }
    }

    None
}
