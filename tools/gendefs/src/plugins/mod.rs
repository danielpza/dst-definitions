//! # Extractor Plugins
//!
//! Provides an extensible plugin pipeline for static AST analysis of Don't Starve Together Lua files.
//!
//! ## Pipeline Architecture
//! Each plugin implements [`Plugin`] and inspects the parsed [`full_moon::ast::Ast`] within an
//! [`ExtractContext`]. Plugins run sequentially in [`PluginRegistry`], enriching the target [`Unit`]
//! intermediate representation:
//!
//! 1. **`RequiresPlugin`**: Scans `local X = require "path"` mappings.
//! 2. **`ClassesPlugin`**: Finds `Class(ctor)` or `Class(Base, ctor)` definitions, fields, and constructor parameters.
//! 3. **`ActionsPlugin`**: Extracts global action table declarations (e.g. `ACTIONS = { REPAIR = Action(), ... }`).
//! 4. **`MethodsPlugin`**: Scans `function Class:Method(...)` stubs and method body fields.

pub mod actions;
pub mod classes;
pub mod constants;
pub mod entity_replica;
pub mod functions;
pub mod helpers;
pub mod methods;
pub mod module_table;
pub mod prefab;
pub mod requires;

pub use actions::ActionsPlugin;
pub use classes::ClassesPlugin;
pub use constants::ConstantsPlugin;
pub use entity_replica::EntityReplicaPlugin;
pub use functions::FunctionsPlugin;
pub use methods::MethodsPlugin;
pub use module_table::ModuleTablePlugin;
pub use prefab::PrefabPlugin;
pub use requires::RequiresPlugin;

use crate::config::Config;
use crate::infer::InferenceEngine;
use crate::model::{ClassDef, FieldDef, Unit};
use crate::resolver::NamingResolver;
use indexmap::IndexMap;

pub struct ExtractContext<'a> {
    pub ast: &'a full_moon::ast::Ast,
    pub rel_path: &'a str,
    pub resolver: &'a NamingResolver,
    pub infer: &'a InferenceEngine<'a>,
    pub config: &'a Config,
}

pub trait Plugin: Send + Sync {
    #[allow(dead_code)]
    fn name(&self) -> &'static str;

    /// Optional filter to determine if this plugin should run on the given file.
    /// Defaults to `true` (processes all files).
    fn should_process(&self, _rel_path: &str) -> bool {
        true
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit);
}

pub struct PluginRegistry {
    plugins: Vec<Box<dyn Plugin>>,
}

impl Default for PluginRegistry {
    fn default() -> Self {
        Self::default_plugins()
    }
}

impl PluginRegistry {
    pub fn new() -> Self {
        Self {
            plugins: Vec::new(),
        }
    }

    pub fn default_plugins() -> Self {
        let mut registry = Self::new();
        registry.register(RequiresPlugin);
        registry.register(ClassesPlugin);
        registry.register(EntityReplicaPlugin);
        registry.register(PrefabPlugin);
        registry.register(ActionsPlugin);
        registry.register(MethodsPlugin);
        registry.register(ModuleTablePlugin);
        registry.register(ConstantsPlugin);
        registry.register(FunctionsPlugin);
        registry
    }

    pub fn register<P: Plugin + 'static>(&mut self, plugin: P) {
        self.plugins.push(Box::new(plugin));
    }

    pub fn extract(&self, ctx: &ExtractContext) -> Option<Unit> {
        let mut unit = Unit::new(ctx.rel_path.to_string());
        for plugin in &self.plugins {
            if plugin.should_process(ctx.rel_path) {
                plugin.extract(ctx, &mut unit);
            }
        }

        // Scan for extra override-defined classes associated with this file namespace
        let file_class_name = ctx.resolver.class_name_for_rel_path(ctx.rel_path, "");
        let prefix = format!("{}.", file_class_name);
        for (override_class_name, class_cfg) in &ctx.config.overrides.classes {
            if (override_class_name.starts_with(&prefix) || override_class_name == &file_class_name)
                && !unit.classes.iter().any(|c| &c.class_name == override_class_name)
            {
                let mut fields = IndexMap::new();
                for (fname, fty) in &class_cfg.fields {
                    let (clean_ty, opt) = if let Some(stripped) = fty.strip_suffix('?') {
                        (stripped.to_string(), true)
                    } else {
                        (fty.clone(), false)
                    };
                    fields.insert(
                        fname.clone(),
                        FieldDef {
                            name: fname.clone(),
                            ty: clean_ty,
                            optional: opt,
                        },
                    );
                }

                let extra_class = ClassDef {
                    lua_name: String::new(),
                    class_name: override_class_name.clone(),
                    base_local: None,
                    parent_class_name: class_cfg.super_class.clone(),
                    ctor_params: Vec::new(),
                    ctor_overloads: class_cfg
                        .constructor
                        .as_ref()
                        .map(|c| c.overloads.clone())
                        .unwrap_or_default(),
                    fields,
                    methods: Vec::new(),
                    is_extension: false,
                };
                unit.classes.insert(0, extra_class);
            }
        }

        if unit.is_empty() {
            None
        } else {
            Some(unit)
        }
    }
}
