//! # Entity Replica Extractor Plugin
//!
//! ### Purpose
//! Extracts network replica definitions configured in `[plugins.entity_replica]`, which extends entity scripts with
//! replica management methods and defines replicatable component tables.
//!
//! ### Handled Patterns
//! - `local <TABLE> = { ... }` / `<TABLE> = { ... }` -> `---@class <CLASS_NAME>` with optional replica fields.
//! - Extension methods on configured target class (e.g. `ValidateReplicaComponent`, `ReplicateComponent`, etc.).
//!
//! ### Effect on Unit
//! Adds a [`crate::model::ClassDef`] populated with replica components,
//! and optionally attaches methods to the extended class.

use full_moon::ast::{Block, Expression, Field, Stmt, TableConstructor, Var};
use indexmap::IndexMap;

use crate::config::EntityReplicaPluginConfig;
use crate::model::{ClassDef, FieldDef, Unit};
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct EntityReplicaPlugin;

impl Plugin for EntityReplicaPlugin {
    fn name(&self) -> &'static str {
        "entity_replica"
    }

    fn should_process(&self, _rel_path: &str) -> bool {
        true
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        let Some(cfg) = find_entity_replica_config(ctx) else {
            return;
        };

        let replica_class = extract_replicatable_components(ctx.ast.nodes(), cfg);
        unit.classes.push(replica_class);

        // If configured, create a stub class for extend_class in this unit so MethodsPlugin can attach methods to it
        if let Some(ref ext_name) = cfg.extend_class {
            let lua_name = cfg
                .extend_lua_name
                .clone()
                .unwrap_or_else(|| ext_name.split('.').next_back().unwrap_or(ext_name).to_string());
            unit.classes.push(ClassDef {
                lua_name,
                class_name: ext_name.clone(),
                base_local: None,
                parent_class_name: None,
                ctor_params: Vec::new(),
                ctor_overloads: Vec::new(),
                fields: IndexMap::new(),
                methods: Vec::new(),
                is_extension: true,
            });
        }
    }
}

fn find_entity_replica_config<'a>(
    ctx: &'a ExtractContext,
) -> Option<&'a EntityReplicaPluginConfig> {
    if let Some(cfg) = ctx.config.plugins.entity_replica.get(ctx.rel_path) {
        return Some(cfg);
    }

    for (key, cfg) in &ctx.config.plugins.entity_replica {
        if ctx.rel_path == key || ctx.rel_path.ends_with(key) {
            return Some(cfg);
        }
    }

    None
}

fn extract_replicatable_components(
    block: &Block,
    cfg: &EntityReplicaPluginConfig,
) -> ClassDef {
    let mut fields = IndexMap::new();

    for stmt in block.stmts() {
        match stmt {
            Stmt::LocalAssignment(local_assign) => {
                for (name_tok, expr) in local_assign
                    .names()
                    .iter()
                    .zip(local_assign.expressions().iter())
                {
                    if name_tok.token().to_string().trim() == cfg.table {
                        collect_fields_from_table_expr(expr, &mut fields, cfg);
                    }
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    if let Var::Name(name_tok) = var
                        && name_tok.token().to_string().trim() == cfg.table
                    {
                        collect_fields_from_table_expr(expr, &mut fields, cfg);
                    }
                }
            }
            _ => {}
        }
    }

    let lua_name = cfg
        .lua_name
        .clone()
        .unwrap_or_else(|| {
            cfg.class_name
                .split('.')
                .next_back()
                .unwrap_or(&cfg.class_name)
                .to_string()
        });

    ClassDef {
        lua_name,
        class_name: cfg.class_name.clone(),
        base_local: None,
        parent_class_name: None,
        ctor_params: Vec::new(),
        ctor_overloads: Vec::new(),
        fields,
        methods: Vec::new(),
        is_extension: false,
    }
}

fn collect_fields_from_table_expr(
    expr: &Expression,
    fields: &mut IndexMap<String, FieldDef>,
    cfg: &EntityReplicaPluginConfig,
) {
    if let Expression::TableConstructor(table) = expr {
        collect_fields_from_table(table, fields, cfg);
    }
}

fn collect_fields_from_table(
    table: &TableConstructor,
    fields: &mut IndexMap<String, FieldDef>,
    cfg: &EntityReplicaPluginConfig,
) {
    for field in table.fields() {
        if let Field::NameKey { key, .. } = field {
            let name = key.token().to_string().trim().to_string();
            let ty = format!("{}.{}", cfg.field_namespace, name);
            fields.insert(
                name.clone(),
                FieldDef {
                    name,
                    ty,
                    optional: true,
                },
            );
        }
    }
}
