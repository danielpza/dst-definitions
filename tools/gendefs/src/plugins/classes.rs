//! # Classes Extractor Plugin
//!
//! ### Purpose
//! Discovers class definitions created with DST's `Class(...)` constructor helper, extracts constructor
//! parameters, determines base class inheritance, and scans initial `self.<field>` assignments.
//!
//! ### Handled Patterns
//! - Single-argument base classes: `local Widget = Class(function(self, name) ... end)`
//! - Subclasses with inheritance: `local Button = Class(Widget, function(self, text) ... end)`
//! - Field assignments in constructor bodies (including within nested `if`, `else`, and `do` blocks).
//! - Drops the leading `self` parameter so call-site definitions overload cleanly as `fun(param1, ...): ClassType`.
//!
//! ### Effect on Unit
//! Adds [`crate::model::ClassDef`] items to `unit.classes`, including initial fields and constructor signatures.

use full_moon::ast::{
    Call, Expression, FunctionArgs, Parameter, Prefix, Stmt, Suffix, Var,
};
use indexmap::IndexMap;

use super::helpers::{
    collect_block_fields_and_locals, is_param_optional_in_block, match_function_body,
    match_ident_name,
};
use crate::model::{ClassDef, ParamDef, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct ClassesPlugin;

impl Plugin for ClassesPlugin {
    fn name(&self) -> &'static str {
        "classes"
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        let classes = extract_classes(ctx, &unit.requires);
        unit.classes.extend(classes);
    }
}

fn extract_classes(ctx: &ExtractContext, requires: &IndexMap<String, String>) -> Vec<ClassDef> {
    let mut classes = Vec::new();
    let block = ctx.ast.nodes();

    for stmt in block.stmts() {
        match stmt {
            Stmt::LocalAssignment(local_assign) => {
                for (name_tok, expr) in local_assign
                    .names()
                    .iter()
                    .zip(local_assign.expressions().iter())
                {
                    let lua_name = name_tok.token().to_string().trim().to_string();
                    if let Some(class_def) = try_parse_class(&lua_name, expr, ctx, requires) {
                        classes.push(class_def);
                    }
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    if let Var::Name(name_tok) = var {
                        let lua_name = name_tok.token().to_string().trim().to_string();
                        if let Some(class_def) = try_parse_class(&lua_name, expr, ctx, requires) {
                            classes.push(class_def);
                        }
                    }
                }
            }
            _ => {}
        }
    }

    if let Some(full_moon::ast::LastStmt::Return(ret_stmt)) = block.last_stmt() {
        for expr in ret_stmt.returns() {
            let file_stem = ctx
                .rel_path
                .trim_end_matches(".lua")
                .rsplit('/')
                .next()
                .unwrap_or("");
            let fallback_lua_name = if !file_stem.is_empty() {
                let mut chars = file_stem.chars();
                match chars.next() {
                    None => String::new(),
                    Some(first) => first.to_uppercase().collect::<String>() + chars.as_str(),
                }
            } else {
                "AnonymousClass".to_string()
            };
            if let Some(class_def) = try_parse_class(&fallback_lua_name, expr, ctx, requires) {
                classes.push(class_def);
            }
        }
    }

    classes
}

fn try_parse_class(
    lua_name: &str,
    expr: &Expression,
    ctx: &ExtractContext,
    requires: &IndexMap<String, String>,
) -> Option<ClassDef> {
    let Expression::FunctionCall(func_call) = expr else {
        return None;
    };
    let Prefix::Name(name_tok) = func_call.prefix() else {
        return None;
    };
    if name_tok.token().to_string().trim() != "Class" {
        return None;
    }

    for suffix in func_call.suffixes() {
        if let Suffix::Call(Call::AnonymousCall(FunctionArgs::Parentheses { arguments, .. })) =
            suffix
        {
            let args: Vec<_> = arguments.iter().collect();
            if args.is_empty() {
                return None;
            }

            let (base_local, ctor_fn_body) = if args.len() == 1 {
                (None, match_function_body(args[0]))
            } else {
                let base_name = match_ident_name(args[0]);
                (base_name, match_function_body(args[1]))
            };

            let class_name = ctx.resolver.class_name_for_rel_path(ctx.rel_path, lua_name);
            let mut parent_class_name = base_local
                .as_deref()
                .and_then(|b| requires.get(b).map(|r| ctx.resolver.class_name_for_require(r)));

            // Apply super class override if specified
            if let Some(class_cfg) = ctx.config.overrides.classes.get(&class_name)
                && let Some(super_cls) = &class_cfg.super_class
            {
                parent_class_name = Some(super_cls.clone());
            }

            let mut fields = IndexMap::new();
            let mut ctor_params = Vec::new();
            let mut ctor_overloads = Vec::new();

            if let Some(class_cfg) = ctx.config.overrides.classes.get(&class_name)
                && let Some(ctor_cfg) = &class_cfg.constructor
            {
                ctor_overloads = ctor_cfg.overloads.clone();
            }

            if let Some(body) = ctor_fn_body {
                let mut locals = IndexMap::new();
                collect_block_fields_and_locals(
                    body.block(),
                    &mut fields,
                    &mut locals,
                    requires,
                    ctx.infer,
                );

                // Parameters minus first `self`
                let params: Vec<_> = body.parameters().iter().collect();
                for (i, param) in params.iter().enumerate() {
                    if i == 0 {
                        continue; // skip `self`
                    }
                    if let Parameter::Name(tok) = param {
                        let pname = tok.token().to_string().trim().to_string();
                        let (ty, optional) = if let Some(overridden) =
                            ctx.infer.infer_method_param_type(&class_name, "__init", &pname)
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
                        ctor_params.push(ParamDef {
                            name: pname,
                            ty,
                            optional,
                        });
                    }
                }
            }

            // Apply field overrides and new fields from config
            if let Some(class_cfg) = ctx.config.overrides.classes.get(&class_name) {
                for (fname, fty) in &class_cfg.fields {
                    let (clean_ty, opt) = if let Some(stripped) = fty.strip_suffix('?') {
                        (stripped.to_string(), true)
                    } else {
                        (fty.clone(), false)
                    };
                    fields.insert(
                        fname.clone(),
                        crate::model::FieldDef {
                            name: fname.clone(),
                            ty: clean_ty,
                            optional: opt,
                        },
                    );
                }
            }

            return Some(ClassDef {
                lua_name: lua_name.to_string(),
                class_name,
                base_local,
                parent_class_name,
                ctor_params,
                ctor_overloads,
                fields,
                methods: Vec::new(),
                is_extension: false,
            });
        }
    }

    None
}
