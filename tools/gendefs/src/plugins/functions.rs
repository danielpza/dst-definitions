//! # Functions Extractor Plugin
//!
//! ### Purpose
//! Extracts top-level global functions (e.g. `function Foo(...) end`, `Foo = function(...) end`)
//! and functions injected into environments (e.g. `env.AddComponentPostInit = function(...) end` in configured files).
//!
//! ### Handled Patterns
//! - Top-level global function declarations: `function ModInfoname(name) ... end`
//! - Top-level global assignments of anonymous functions: `GetModConfigData = function(...) ... end`
//! - Top-level global tables initialized as `{}`: `ReleaseID = { IDs = {}, Current = nil }` -> `GlobalDef`
//! - Function assignments to configured `env_var.*`: `env.AddComponentPostInit = function(component, fn) ... end`
//!
//! ### Effect on Unit
//! Adds [`crate::model::FunctionDef`] and [`crate::model::GlobalDef`] to `unit.functions` and `unit.globals`.

use full_moon::ast::{
    Block, Expression, FunctionBody, Parameter, Prefix, Stmt, Suffix, Var,
};

use super::helpers::is_param_optional_in_block;
use crate::config::EnvExporterConfig;
use crate::model::{FunctionDef, GlobalDef, ParamDef, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct FunctionsPlugin;

impl Plugin for FunctionsPlugin {
    fn name(&self) -> &'static str {
        "functions"
    }

    fn should_process(&self, _rel_path: &str) -> bool {
        true
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        let files = &ctx.config.plugins.functions.files;
        if !files.is_empty()
            && !files
                .iter()
                .any(|f| ctx.rel_path == f || ctx.rel_path.ends_with(f))
        {
            return;
        }

        let env_exporter_cfg = find_env_exporter_config(ctx);
        extract_functions_from_block(ctx.ast.nodes(), unit, ctx, env_exporter_cfg);
    }
}

fn find_env_exporter_config<'a>(ctx: &'a ExtractContext) -> Option<&'a EnvExporterConfig> {
    if let Some(cfg) = ctx.config.plugins.functions.env_exporters.get(ctx.rel_path) {
        return Some(cfg);
    }

    for (key, cfg) in &ctx.config.plugins.functions.env_exporters {
        if ctx.rel_path == key || ctx.rel_path.ends_with(key) {
            return Some(cfg);
        }
    }

    None
}

fn extract_functions_from_block(
    block: &Block,
    unit: &mut Unit,
    ctx: &ExtractContext,
    env_exporter_cfg: Option<&EnvExporterConfig>,
) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::FunctionDeclaration(func_decl) => {
                let func_name = func_decl.name();
                let names: Vec<_> = func_name.names().iter().collect();
                if names.is_empty() {
                    continue;
                }

                // If it's a method on a class (e.g. `Class:Method` or `Class.Method` where Class is in unit.classes), skip it (MethodsPlugin handles it)
                let first_name = names[0].token().to_string().trim().to_string();
                let is_env_var = env_exporter_cfg.is_some_and(|cfg| cfg.env_var == first_name);
                if names.len() > 1 || func_name.method_name().is_some() {
                    if !is_env_var {
                        // Check if it's CurrentRelease.GreaterOrEqualTo etc.
                        let full_name = if let Some(m) = func_name.method_name() {
                            format!("{}:{}", first_name, m.token().to_string().trim())
                        } else {
                            format!("{}.{}", first_name, names[1].token().to_string().trim())
                        };
                        let fdef = parse_function_def(&full_name, func_decl.body(), ctx);
                        unit.functions.push(fdef);
                    }
                    continue;
                }

                // Check if this matches configured exporter functions
                if let Some(env_cfg) = env_exporter_cfg
                    && env_cfg.functions.contains(&first_name)
                {
                    extract_env_functions_from_body(
                        func_decl.body().block(),
                        unit,
                        ctx,
                        &env_cfg.env_var,
                    );
                }

                // If this is a global function (e.g. `function ModInfoname(name)`)
                // Exclude local functions (FunctionDeclaration in Lua can be local only if it's LocalFunction, which is Stmt::LocalFunction)
                let fdef = parse_function_def(&first_name, func_decl.body(), ctx);
                unit.functions.push(fdef);
            }
            Stmt::LocalFunction(local_func) => {
                let fname = local_func.name().token().to_string().trim().to_string();
                if let Some(env_cfg) = env_exporter_cfg
                    && env_cfg.functions.contains(&fname)
                {
                    extract_env_functions_from_body(
                        local_func.body().block(),
                        unit,
                        ctx,
                        &env_cfg.env_var,
                    );
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    match var {
                        Var::Name(tok) => {
                            let name = tok.token().to_string().trim().to_string();
                            if let Expression::Function(func_expr) = expr {
                                let fdef = parse_function_def(&name, func_expr.body(), ctx);
                                unit.functions.push(fdef);
                            } else if let Expression::TableConstructor(_) = expr {
                                // E.g. `ReleaseID = { IDs = {}, Current = nil }` or `CurrentRelease = {}`
                                if !unit.globals.iter().any(|g| g.name == name) {
                                    unit.globals.push(GlobalDef {
                                        name,
                                        ty: "table".to_string(),
                                        entries: None,
                                    });
                                }
                            }
                        }
                        Var::Expression(var_expr) => {
                            if let Prefix::Name(tok) = var_expr.prefix() {
                                let target_name = tok.token().to_string().trim().to_string();
                                let suffixes: Vec<_> = var_expr.suffixes().collect();
                                if suffixes.len() == 1
                                    && let Suffix::Index(full_moon::ast::Index::Dot {
                                        name: field_tok,
                                        ..
                                    }) = &suffixes[0]
                                {
                                    let field_name =
                                        field_tok.token().to_string().trim().to_string();
                                    if let Expression::Function(func_expr) = expr {
                                        let full_name = format!("{}.{}", target_name, field_name);
                                        let fdef = parse_function_def(
                                            &full_name,
                                            func_expr.body(),
                                            ctx,
                                        );
                                        unit.functions.push(fdef);
                                    }
                                }
                            }
                        }
                        _ => {}
                    }
                }
            }
            _ => {}
        }
    }
}

fn extract_env_functions_from_body(
    block: &Block,
    unit: &mut Unit,
    ctx: &ExtractContext,
    env_var: &str,
) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    if let Var::Expression(var_expr) = var
                        && let Prefix::Name(tok) = var_expr.prefix()
                        && tok.token().to_string().trim() == env_var
                    {
                        let suffixes: Vec<_> = var_expr.suffixes().collect();
                        if suffixes.len() == 1
                            && let Suffix::Index(full_moon::ast::Index::Dot { name, .. }) =
                                &suffixes[0]
                        {
                            let func_name = name.token().to_string().trim().to_string();
                            if let Expression::Function(func_expr) = expr {
                                let fdef = parse_function_def(&func_name, func_expr.body(), ctx);
                                unit.functions.push(fdef);
                            } else if let Expression::Var(Var::Name(assigned_var)) = expr {
                                let assigned_name =
                                    assigned_var.token().to_string().trim().to_string();
                                // E.g. `env.AddModCharacter = AddModCharacter`
                                // Or `env.Prefab = Prefab`
                                if !unit.functions.iter().any(|f| f.name == func_name) {
                                    // Search in the ast for a local or global function with `assigned_name`
                                    if let Some(fdef) = find_function_in_ast(
                                        ctx.ast.nodes(),
                                        &assigned_name,
                                        &func_name,
                                        ctx,
                                    ) {
                                        unit.functions.push(fdef);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Stmt::If(if_stmt) => {
                extract_env_functions_from_body(if_stmt.block(), unit, ctx, env_var);
                if let Some(else_ifs) = if_stmt.else_if() {
                    for else_if in else_ifs {
                        extract_env_functions_from_body(else_if.block(), unit, ctx, env_var);
                    }
                }
                if let Some(else_block) = if_stmt.else_block() {
                    extract_env_functions_from_body(else_block, unit, ctx, env_var);
                }
            }
            Stmt::Do(do_stmt) => {
                extract_env_functions_from_body(do_stmt.block(), unit, ctx, env_var);
            }
            _ => {}
        }
    }
}

fn find_function_in_ast(
    block: &Block,
    target_ident: &str,
    export_name: &str,
    ctx: &ExtractContext,
) -> Option<FunctionDef> {
    for stmt in block.stmts() {
        match stmt {
            Stmt::LocalFunction(lf) => {
                if lf.name().token().to_string().trim() == target_ident {
                    return Some(parse_function_def(export_name, lf.body(), ctx));
                }
            }
            Stmt::FunctionDeclaration(fd) => {
                let names: Vec<_> = fd.name().names().iter().collect();
                if names.len() == 1 && names[0].token().to_string().trim() == target_ident {
                    return Some(parse_function_def(export_name, fd.body(), ctx));
                }
            }
            _ => {}
        }
    }
    None
}

pub(crate) fn parse_function_def(
    fn_name: &str,
    body: &FunctionBody,
    ctx: &ExtractContext,
) -> FunctionDef {
    let mut params = Vec::new();
    for param in body.parameters().iter() {
        match param {
            Parameter::Name(tok) => {
                let pname = tok.token().to_string().trim().to_string();
                let (ty, optional) = if let Some(overridden) =
                    ctx.infer.infer_global_param_type(fn_name, &pname)
                {
                    if let Some(stripped) = overridden.strip_suffix('?') {
                        (stripped.to_string(), true)
                    } else {
                        (overridden, false)
                    }
                } else {
                    let opt = is_param_optional_in_block(body.block(), &pname);
                    let param_ty = ctx.infer.infer_param_type(&pname);
                    (param_ty, opt)
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

    if let Some(fn_cfg) = ctx.config.overrides.globals.functions.get(fn_name) {
        for (pname, pty) in &fn_cfg.params {
            if !params.iter().any(|p| &p.name == pname) {
                let (clean_ty, opt) = if let Some(stripped) = pty.strip_suffix('?') {
                    (stripped.to_string(), true)
                } else {
                    (pty.clone(), false)
                };
                params.push(ParamDef {
                    name: pname.clone(),
                    ty: clean_ty,
                    optional: opt,
                });
            }
        }
        if let Some(ret) = &fn_cfg.return_type {
            returns.push(ret.clone());
        }
        returns.extend(fn_cfg.returns.clone());
        overloads.extend(fn_cfg.overloads.clone());
    }

    FunctionDef {
        name: fn_name.to_string(),
        params,
        returns,
        overloads,
    }
}
