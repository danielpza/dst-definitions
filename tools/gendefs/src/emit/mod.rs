mod class;
mod global;

pub use class::emit_class;
pub use global::{emit_function, emit_global};

use std::fmt::Write;

use crate::model::Unit;

pub fn emit_unit(unit: &Unit) -> String {
    let mut out = String::new();
    writeln!(out, "---@meta").unwrap();
    writeln!(out, "---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global\n").unwrap();

    for alias in &unit.aliases {
        writeln!(out, "---@alias {} {}", alias.name, alias.target).unwrap();
    }
    if !unit.aliases.is_empty() {
        writeln!(out).unwrap();
    }

    for class in &unit.classes {
        emit_class(&mut out, class);
    }

    for constant in &unit.constants {
        if let Some(ty) = &constant.ty {
            writeln!(out, "---@type {}", ty).unwrap();
        }
        writeln!(out, "{} = {}", constant.name, constant.value).unwrap();
    }
    if !unit.constants.is_empty() {
        writeln!(out).unwrap();
    }

    for enum_def in &unit.enums {
        if let Some(enum_type) = &enum_def.enum_type {
            writeln!(out, "---@enum {}", enum_type).unwrap();
        }
        if enum_def.fields.is_empty() {
            writeln!(out, "{} = {{}}\n", enum_def.name).unwrap();
        } else {
            writeln!(out, "{} = {{", enum_def.name).unwrap();
            for field in &enum_def.fields {
                if field.key.is_empty() {
                    writeln!(out, "   {},", field.value).unwrap();
                } else {
                    writeln!(out, "   {} = {},", field.key, field.value).unwrap();
                }
            }
            writeln!(out, "}}\n").unwrap();
        }
    }

    let fallback_class_lua = unit
        .classes
        .first()
        .map(|c| c.lua_name.as_str())
        .unwrap_or("Action");

    for global in &unit.globals {
        emit_global(&mut out, global, fallback_class_lua);
    }

    for func in &unit.functions {
        emit_function(&mut out, func);
    }

    if let Some(first) = unit.classes.iter().find(|c| !c.is_extension && !c.lua_name.is_empty()) {
        writeln!(out, "return {}", first.lua_name).unwrap();
    }

    out
}
