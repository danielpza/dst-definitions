//! # Prefab Extractor Plugin
//!
//! ### Purpose
//! Extracts entity definitions (like `ThePlayer` / `ds.prefabs.player_common` and `TheWorld` / `ds.prefabs.world`)
//! from complex prefab scripts (`prefabs/player_common.lua`, `prefabs/world.lua`).
//! Because these singleton entities are created inside factory functions rather than
//! typical `Class(...)` constructors, this plugin inspects the AST to extract:
//! - Methods attached to the instance (`inst.MethodName = fn` / `inst.MethodName = fns.Method` / anonymous functions)
//! - Components dynamically attached via `inst.entity:Add<Component>()`
//! - Instance fields assigned on `inst.<field> = ...`
//!
//! ### Effect on Unit
//! Adds a [`ClassDef`] for the prefab entity (inheriting from `ds.entityscript`).

use full_moon::ast::{
    Block, Call, Expression, FunctionBody, Parameter, Prefix, Stmt, Suffix, Var,
};
use indexmap::IndexMap;

use super::helpers::{is_param_optional_in_block, match_ident_name};
use crate::model::{ClassDef, FieldDef, MethodDef, ParamDef, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct PrefabPlugin;

impl Plugin for PrefabPlugin {
    fn name(&self) -> &'static str {
        "prefab"
    }

    fn should_process(&self, _rel_path: &str) -> bool {
        // Will check against configured prefabs in extract
        true
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        let Some(prefab_cfg) = find_prefab_config(ctx) else {
            return;
        };

        let class_def = extract_prefab_class(ctx, prefab_cfg);
        unit.classes.push(class_def);
    }
}

fn find_prefab_config<'a>(ctx: &'a ExtractContext) -> Option<&'a crate::config::PrefabConfig> {
    if let Some(cfg) = ctx.config.plugins.prefabs.get(ctx.rel_path) {
        return Some(cfg);
    }

    for (key, cfg) in &ctx.config.plugins.prefabs {
        if ctx.rel_path == key || ctx.rel_path.ends_with(key) {
            return Some(cfg);
        }
    }

    None
}

fn extract_prefab_class(ctx: &ExtractContext, cfg: &crate::config::PrefabConfig) -> ClassDef {
    let block = ctx.ast.nodes();

    let mut local_fns: IndexMap<String, &FunctionBody> = IndexMap::new();
    collect_local_functions(block, &mut local_fns);

    let mut fields: IndexMap<String, FieldDef> = IndexMap::new();
    let mut methods: Vec<MethodDef> = Vec::new();

    for (name, ty_str) in &cfg.default_fields {
        let (ty, optional) = if let Some(stripped) = ty_str.strip_suffix('?') {
            (stripped.to_string(), true)
        } else {
            (ty_str.clone(), false)
        };
        fields.insert(
            name.clone(),
            FieldDef {
                name: name.clone(),
                ty,
                optional,
            },
        );
    }

    scan_block_for_prefab(block, &local_fns, &mut fields, &mut methods, cfg, ctx);

    ClassDef {
        lua_name: cfg.lua_name.clone(),
        class_name: cfg.class_name.clone(),
        base_local: None,
        parent_class_name: Some(
            cfg.parent_class
                .clone()
                .unwrap_or_else(|| "ds.entityscript".to_string()),
        ),
        ctor_params: Vec::new(),
        ctor_overloads: Vec::new(),
        fields,
        methods,
        is_extension: false,
    }
}

fn collect_local_functions<'a>(
    block: &'a Block,
    local_fns: &mut IndexMap<String, &'a FunctionBody>,
) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::LocalFunction(lf) => {
                let name = lf.name().token().to_string().trim().to_string();
                local_fns.insert(name, lf.body());
            }
            Stmt::FunctionDeclaration(fd) => {
                let name_tokens: Vec<_> = fd.name().names().iter().collect();
                if name_tokens.len() == 1 && fd.name().method_name().is_none() {
                    let name = name_tokens[0].token().to_string().trim().to_string();
                    local_fns.insert(name, fd.body());
                } else if name_tokens.len() == 2 && fd.name().method_name().is_none() {
                    let prefix = name_tokens[0].token().to_string().trim().to_string();
                    let fn_name = name_tokens[1].token().to_string().trim().to_string();
                    local_fns.insert(format!("{}.{}", prefix, fn_name), fd.body());
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    if let Var::Expression(var_expr) = var
                        && let Prefix::Name(tok) = var_expr.prefix()
                    {
                        let prefix = tok.token().to_string().trim().to_string();
                        let suffixes: Vec<_> = var_expr.suffixes().collect();
                        if suffixes.len() == 1
                            && let Suffix::Index(full_moon::ast::Index::Dot { name, .. }) =
                                &suffixes[0]
                        {
                            let field = name.token().to_string().trim().to_string();
                            if let Expression::Function(anon) = expr {
                                local_fns.insert(format!("{}.{}", prefix, field), anon.body());
                            }
                        }
                    }
                }
            }
            _ => {}
        }
    }
}

fn scan_block_for_prefab(
    block: &Block,
    local_fns: &IndexMap<String, &FunctionBody>,
    fields: &mut IndexMap<String, FieldDef>,
    methods: &mut Vec<MethodDef>,
    cfg: &crate::config::PrefabConfig,
    ctx: &ExtractContext,
) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::FunctionDeclaration(fd) => {
                scan_block_for_prefab(fd.body().block(), local_fns, fields, methods, cfg, ctx);
            }
            Stmt::LocalFunction(lf) => {
                scan_block_for_prefab(lf.body().block(), local_fns, fields, methods, cfg, ctx);
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    handle_prefab_assignment(
                        var, expr, local_fns, fields, methods, cfg, ctx,
                    );
                }
            }
            Stmt::LocalAssignment(local_assign) => {
                for expr in local_assign.expressions() {
                    if let Expression::Function(anon_fn) = expr {
                        scan_block_for_prefab(
                            anon_fn.body().block(),
                            local_fns,
                            fields,
                            methods,
                            cfg,
                            ctx,
                        );
                    }
                }
            }
            Stmt::FunctionCall(call) => {
                handle_prefab_call(call, fields, cfg);
            }
            Stmt::If(if_stmt) => {
                scan_block_for_prefab(if_stmt.block(), local_fns, fields, methods, cfg, ctx);
                if let Some(else_ifs) = if_stmt.else_if() {
                    for else_if in else_ifs {
                        scan_block_for_prefab(
                            else_if.block(),
                            local_fns,
                            fields,
                            methods,
                            cfg,
                            ctx,
                        );
                    }
                }
                if let Some(else_block) = if_stmt.else_block() {
                    scan_block_for_prefab(else_block, local_fns, fields, methods, cfg, ctx);
                }
            }
            Stmt::Do(do_stmt) => {
                scan_block_for_prefab(do_stmt.block(), local_fns, fields, methods, cfg, ctx);
            }
            _ => {}
        }
    }
}

fn handle_prefab_assignment(
    var: &Var,
    expr: &Expression,
    local_fns: &IndexMap<String, &FunctionBody>,
    fields: &mut IndexMap<String, FieldDef>,
    methods: &mut Vec<MethodDef>,
    cfg: &crate::config::PrefabConfig,
    ctx: &ExtractContext,
) {
    let Var::Expression(var_expr) = var else {
        return;
    };
    let Prefix::Name(tok) = var_expr.prefix() else {
        return;
    };
    let target_name = tok.token().to_string().trim().to_string();
    if !cfg.target_names.is_empty() && !cfg.target_names.iter().any(|t| t == &target_name) {
        return;
    }

    let suffixes: Vec<_> = var_expr.suffixes().collect();
    if suffixes.len() != 1 {
        return;
    }
    let Suffix::Index(full_moon::ast::Index::Dot { name, .. }) = &suffixes[0] else {
        return;
    };
    let member_name = name.token().to_string().trim().to_string();

    // Check if expr is a dotted function reference (e.g. `fns.IsInMiasma` or `ex_fns.EnableTargetLocking`)
    if let Expression::Var(Var::Expression(rhs_expr)) = expr
        && let Prefix::Name(rhs_prefix_tok) = rhs_expr.prefix()
    {
        let prefix_str = rhs_prefix_tok.token().to_string().trim().to_string();
        let rhs_suffixes: Vec<_> = rhs_expr.suffixes().collect();
        if rhs_suffixes.len() == 1
            && let Suffix::Index(full_moon::ast::Index::Dot {
                name: rhs_dot_name, ..
            }) = &rhs_suffixes[0]
        {
            let rhs_fn_name = rhs_dot_name.token().to_string().trim().to_string();
            let full_key = format!("{}.{}", prefix_str, rhs_fn_name);
            if let Some(body) = local_fns.get(&full_key) {
                let method_def = extract_method_from_params_and_block(
                    &member_name,
                    body.parameters(),
                    body.block(),
                    cfg,
                    ctx,
                );
                if !methods.iter().any(|m| m.name == member_name) {
                    methods.push(method_def);
                }
                return;
            }
        }
    }

    // Check if expr is a direct identifier for a local function
    if let Some(rhs_fn_name) = match_ident_name(expr)
        && let Some(body) = local_fns.get(&rhs_fn_name)
    {
        let method_def = extract_method_from_params_and_block(
            &member_name,
            body.parameters(),
            body.block(),
            cfg,
            ctx,
        );
        if !methods.iter().any(|m| m.name == member_name) {
            methods.push(method_def);
        }
        return;
    }

    if let Expression::Function(anon_fn) = expr {
        let method_def = extract_method_from_params_and_block(
            &member_name,
            anon_fn.body().parameters(),
            anon_fn.body().block(),
            cfg,
            ctx,
        );
        if !methods.iter().any(|m| m.name == member_name) {
            methods.push(method_def);
        }
        return;
    }

    // Check explicit class field override from config first
    let field_ty = if let Some(class_cfg) = ctx.config.overrides.classes.get(&cfg.class_name)
        && let Some(ty) = class_cfg.fields.get(&member_name)
    {
        ty.clone()
    } else {
        ctx.infer
            .infer_expr_type(expr, &IndexMap::new(), &IndexMap::new())
    };

    if !fields.contains_key(&member_name) {
        fields.insert(
            member_name.clone(),
            FieldDef {
                name: member_name,
                ty: field_ty,
                optional: true,
            },
        );
    }
}

fn handle_prefab_call(
    call: &full_moon::ast::FunctionCall,
    fields: &mut IndexMap<String, FieldDef>,
    cfg: &crate::config::PrefabConfig,
) {
    let Prefix::Name(tok) = call.prefix() else {
        return;
    };
    let inst_name = tok.token().to_string().trim().to_string();
    if !cfg.target_names.is_empty() && !cfg.target_names.iter().any(|t| t == &inst_name) {
        return;
    }

    let suffixes: Vec<_> = call.suffixes().collect();
    for i in 0..suffixes.len() {
        if let Suffix::Index(full_moon::ast::Index::Dot { name, .. }) = &suffixes[i] {
            let dot_name = name.token().to_string().trim().to_string();
            if dot_name == "entity"
                && let Some(Suffix::Call(Call::MethodCall(entity_call))) = suffixes.get(i + 1)
            {
                let entity_method = entity_call.name().token().to_string().trim().to_string();
                if let Some(comp) = entity_method.strip_prefix("Add") {
                    let comp_ty = if let Some(ref ns) = cfg.component_namespace {
                        format!("{}.{}", ns, comp)
                    } else {
                        "any".to_string()
                    };
                    fields.insert(
                        comp.to_string(),
                        FieldDef {
                            name: comp.to_string(),
                            ty: comp_ty,
                            optional: false,
                        },
                    );
                }
            }
        }
    }
}

fn extract_method_from_params_and_block(
    method_name: &str,
    parameters: &full_moon::ast::punctuated::Punctuated<Parameter>,
    block: &Block,
    cfg: &crate::config::PrefabConfig,
    ctx: &ExtractContext,
) -> MethodDef {
    let mut params = Vec::new();
    let mut is_first = true;

    for param in parameters.iter() {
        match param {
            Parameter::Name(tok) => {
                let pname = tok.token().to_string().trim().to_string();
                if is_first && cfg.receiver_names.iter().any(|r| r == &pname) {
                    is_first = false;
                    continue; // Skip receiver param for colon methods
                }
                is_first = false;

                let (ty, optional) = if let Some(overridden) =
                    ctx.infer
                        .infer_method_param_type(&cfg.class_name, method_name, &pname)
                {
                    if let Some(stripped) = overridden.strip_suffix('?') {
                        (stripped.to_string(), true)
                    } else {
                        (overridden, false)
                    }
                } else {
                    let opt = is_param_optional_in_block(block, &pname);
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

    if let Some(class_cfg) = ctx.config.overrides.classes.get(&cfg.class_name)
        && let Some(method_cfg) = class_cfg.methods.get(method_name)
    {
        if let Some(ret) = &method_cfg.return_type {
            returns.push(ret.clone());
        }
        returns.extend(method_cfg.returns.clone());
        overloads.extend(method_cfg.overloads.clone());
    }

    MethodDef {
        name: method_name.to_string(),
        is_colon: true,
        params,
        returns,
        overloads,
    }
}
