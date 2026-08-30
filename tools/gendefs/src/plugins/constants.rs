//! # Constants Extractor Plugin
//!
//! ### Purpose
//! Extracts top-level global constants, enum tables, aliases, and functions from files configured in `[plugins.constants.files]`.
//!
//! ### Handled Patterns
//! - Global primitive constants: `PI = math.pi`, `ANCHOR_MIDDLE = 0`, `KEY_A = 97` -> `ConstantDef`
//! - Global enum & data tables: `EQUIPSLOTS = { HANDS = "hands", ... }` -> `EnumDef` (with `---@enum` if configured)
//! - Global helper functions: `function RGB(r, g, b) ... end`, `function IsSpecialEventActive(event) ... end` -> `FunctionDef`
//! - Configured type aliases: `ds.hanchor`, `ds.vanchor` -> `AliasDef`
//!
//! ### Effect on Unit
//! Enriches `unit.aliases`, `unit.constants`, `unit.enums`, and `unit.functions`.

use full_moon::ast::{Block, Expression, Field, Stmt, Var};

use super::functions::parse_function_def;
use crate::model::{AliasDef, ConstantDef, EnumDef, EnumField, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct ConstantsPlugin;

impl Plugin for ConstantsPlugin {
    fn name(&self) -> &'static str {
        "constants"
    }

    fn should_process(&self, _rel_path: &str) -> bool {
        true
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        let files = &ctx.config.plugins.constants.files;
        if !files.is_empty()
            && !files
                .iter()
                .any(|f| ctx.rel_path == f || ctx.rel_path.ends_with(f))
        {
            return;
        }

        let allowlist = &ctx.config.plugins.constants.allowlist;

        // 1. Add configured aliases
        for (alias_name, target) in &ctx.config.plugins.constants.aliases {
            unit.aliases.push(AliasDef {
                name: alias_name.clone(),
                target: target.clone(),
            });
        }

        // 2. Extract statements from AST block with filter
        let is_allowed = |name: &str| -> bool {
            allowlist.is_empty() || allowlist.iter().any(|a| a == name)
        };
        extract_from_block(ctx.ast.nodes(), unit, ctx, &is_allowed);
    }
}

fn extract_from_block(
    block: &Block,
    unit: &mut Unit,
    ctx: &ExtractContext,
    is_allowed: &dyn Fn(&str) -> bool,
) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::FunctionDeclaration(func_decl) => {
                let func_name = func_decl.name();
                let names: Vec<_> = func_name.names().iter().collect();
                if names.len() == 1 && func_name.method_name().is_none() {
                    let name = names[0].token().to_string().trim().to_string();
                    if is_allowed(&name) {
                        let fdef = parse_function_def(&name, func_decl.body(), ctx);
                        unit.functions.push(fdef);
                    }
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    if let Var::Name(name_tok) = var {
                        let name = name_tok.token().to_string().trim().to_string();
                        if !is_allowed(&name) {
                            continue;
                        }
                        match expr {
                            Expression::Function(func_expr) => {
                                let fdef = parse_function_def(&name, func_expr.body(), ctx);
                                unit.functions.push(fdef);
                            }
                            Expression::TableConstructor(tc) => {
                                let enum_type = ctx
                                    .config
                                    .plugins
                                    .constants
                                    .enums
                                    .get(&name)
                                    .cloned();
                                let mut fields = Vec::new();
                                for field in tc.fields() {
                                    match field {
                                        Field::NameKey { key, value, .. } => {
                                            fields.push(EnumField {
                                                key: key.token().to_string().trim().to_string(),
                                                value: value.to_string().trim().to_string(),
                                            });
                                        }
                                        Field::ExpressionKey { key, value, .. } => {
                                            fields.push(EnumField {
                                                key: format!("[{}]", key.to_string().trim()),
                                                value: value.to_string().trim().to_string(),
                                            });
                                        }
                                        Field::NoKey(val) => {
                                            fields.push(EnumField {
                                                key: String::new(),
                                                value: val.to_string().trim().to_string(),
                                            });
                                        }
                                        _ => {}
                                    }
                                }
                                unit.enums.push(EnumDef {
                                    name,
                                    enum_type,
                                    fields,
                                });
                            }
                            _ => {
                                let value = expr.to_string().trim().to_string();
                                unit.constants.push(ConstantDef {
                                    name,
                                    value,
                                    ty: None,
                                });
                            }
                        }
                    }
                }
            }
            Stmt::Do(do_stmt) => {
                extract_from_block(do_stmt.block(), unit, ctx, is_allowed);
            }
            _ => {}
        }
    }
}
