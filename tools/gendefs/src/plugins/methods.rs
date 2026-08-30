//! # Methods Extractor Plugin
//!
//! ### Purpose
//! Discovers and records all top-level method declarations on extracted classes, preserves declaration order,
//! infers parameter types, and collects any late `self.<field>` assignments defined in method bodies.
//!
//! ### Handled Patterns
//! - Colon methods: `function Widget:SetPosition(pos, y, z) ... end`
//! - Dot methods / static functions: `function Widget.StaticHelper(a, b) ... end`
//! - Variadic parameter packs: `function Widget:VarArgMethod(...) ... end` -> typed as `...: any`
//! - Discovers any additional fields assigned in methods via `self.some_field = ...`.
//!
//! ### Effect on Unit
//! Appends [`crate::model::MethodDef`] instances to the matching [`crate::model::ClassDef`] in `unit.classes`,
//! and registers any newly discovered fields.

use full_moon::ast::{Block, Parameter, Stmt};
use indexmap::IndexMap;

use super::helpers::{collect_block_fields_and_locals, is_param_optional_in_block};
use crate::model::{MethodDef, ParamDef, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct MethodsPlugin;

impl Plugin for MethodsPlugin {
    fn name(&self) -> &'static str {
        "methods"
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        extract_methods(ctx.ast.nodes(), &mut unit.classes, &unit.requires, ctx);
    }
}

fn extract_methods(
    block: &Block,
    classes: &mut [crate::model::ClassDef],
    requires: &IndexMap<String, String>,
    ctx: &ExtractContext,
) {
    for stmt in block.stmts() {
        if let Stmt::FunctionDeclaration(func_decl) = stmt {
            let func_name = func_decl.name();
            let names: Vec<_> = func_name.names().iter().collect();
            if names.is_empty() {
                continue;
            }

            let class_lua_name = names[0].token().to_string().trim().to_string();
            let is_colon = func_name.method_name().is_some();

            // Method name is either the colon method name, or the second dot-separated name
            let method_name = if let Some(m) = func_name.method_name() {
                m.token().to_string().trim().to_string()
            } else if names.len() >= 2 {
                names[1].token().to_string().trim().to_string()
            } else {
                continue;
            };

            // Find matching class (case-insensitive fallback for Lua vs type namespace e.g. EntityScript vs entityscript)
            if let Some(class_def) = classes.iter_mut().find(|c| {
                c.lua_name == class_lua_name
                    || c.lua_name.eq_ignore_ascii_case(&class_lua_name)
                    || c.class_name
                        .split('.')
                        .next_back()
                        .is_some_and(|last| last.eq_ignore_ascii_case(&class_lua_name))
            }) {
                let mut locals = IndexMap::new();
                let mut method_fields = IndexMap::new();
                collect_block_fields_and_locals(
                    func_decl.body().block(),
                    &mut method_fields,
                    &mut locals,
                    requires,
                    ctx.infer,
                );

                // Add any newly discovered fields from method body
                for (fname, fdef) in method_fields {
                    if !class_def.fields.contains_key(&fname) {
                        class_def.fields.insert(fname, fdef);
                    }
                }

                let mut params = Vec::new();
                for param in func_decl.body().parameters().iter() {
                    match param {
                        Parameter::Name(tok) => {
                            let pname = tok.token().to_string().trim().to_string();
                            let (ty, optional) = if let Some(overridden) = ctx.infer.infer_method_param_type(
                                &class_def.class_name,
                                &method_name,
                                &pname,
                            ) {
                                if let Some(stripped) = overridden.strip_suffix('?') {
                                    (stripped.to_string(), true)
                                } else {
                                    (overridden, false)
                                }
                            } else {
                                let opt = is_param_optional_in_block(func_decl.body().block(), &pname);
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
                    && let Some(method_cfg) = class_cfg.methods.get(&method_name)
                {
                    if let Some(ret) = &method_cfg.return_type {
                        returns.push(ret.clone());
                    }
                    returns.extend(method_cfg.returns.clone());
                    overloads.extend(method_cfg.overloads.clone());
                }

                class_def.methods.push(MethodDef {
                    name: method_name,
                    is_colon,
                    params,
                    returns,
                    overloads,
                });
            }
        }
    }
}
