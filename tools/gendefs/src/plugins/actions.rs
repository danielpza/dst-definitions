//! # Actions Extractor Plugin
//!
//! ### Purpose
//! Extracts action enum/dictionary tables configured in `[plugins.actions]`.
//!
//! ### Handled Patterns
//! - Table declarations matching configured global name (e.g. `ACTIONS = { REPAIR = Action(), ... }`)
//!
//! ### Effect on Unit
//! Adds a [`crate::model::GlobalDef`] for the configured table name with the resolved value type containing
//! all action key identifiers.

use full_moon::ast::{Block, Expression, Field, Stmt, Var};

use crate::config::ActionsPluginConfig;
use crate::model::{GlobalDef, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct ActionsPlugin;

impl Plugin for ActionsPlugin {
    fn name(&self) -> &'static str {
        "actions"
    }

    fn should_process(&self, _rel_path: &str) -> bool {
        true
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        let matched_configs = find_actions_configs(ctx);
        if matched_configs.is_empty() {
            return;
        }

        for cfg in matched_configs {
            let globals = extract_actions(ctx, &unit.classes, cfg);
            unit.globals.extend(globals);
        }
    }
}

fn find_actions_configs<'a>(ctx: &'a ExtractContext) -> Vec<&'a ActionsPluginConfig> {
    let mut matches = Vec::new();
    for (key, cfg) in &ctx.config.plugins.actions {
        if ctx.rel_path == key || ctx.rel_path.ends_with(key) {
            matches.push(cfg);
        }
    }
    matches
}

fn extract_actions(
    ctx: &ExtractContext,
    classes: &[crate::model::ClassDef],
    cfg: &ActionsPluginConfig,
) -> Vec<GlobalDef> {
    let block: &Block = ctx.ast.nodes();
    let mut globals = Vec::new();

    for stmt in block.stmts() {
        if let Stmt::Assignment(assign) = stmt {
            for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                if let Var::Name(name_tok) = var {
                    let name = name_tok.token().to_string().trim().to_string();
                    if name == cfg.global_name
                        && let Expression::TableConstructor(table) = expr
                    {
                        let mut entries = Vec::new();
                        for field in table.fields() {
                            if let Field::NameKey { key, .. } = field {
                                entries.push(key.token().to_string().trim().to_string());
                            }
                        }
                        let action_class = if let Some(ref vt) = cfg.value_type {
                            vt.clone()
                        } else if let Some(first_cls) = classes.first() {
                            first_cls.class_name.clone()
                        } else {
                            format!(
                                "{}.{}",
                                ctx.resolver.class_name_for_rel_path(ctx.rel_path, ""),
                                "action"
                            )
                        };
                        globals.push(GlobalDef {
                            name,
                            ty: format!("table<string, {}>", action_class),
                            entries: Some(entries),
                        });
                    }
                }
            }
        }
    }

    globals
}
