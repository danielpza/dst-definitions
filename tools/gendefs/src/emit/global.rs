use std::fmt::Write;

use crate::model::{FunctionDef, GlobalDef};

pub fn emit_global(out: &mut String, global: &GlobalDef, fallback_class_lua: &str) {
    if let Some(entries) = &global.entries {
        writeln!(out, "---@type {}", global.ty).unwrap();
        writeln!(out, "{} = {{", global.name).unwrap();
        for entry in entries {
            writeln!(out, "   {} = {}(),", entry, fallback_class_lua).unwrap();
        }
        writeln!(out, "}}\n").unwrap();
    } else {
        writeln!(out, "---@type {}", global.ty).unwrap();
        writeln!(out, "{} = {{}}\n", global.name).unwrap();
    }
}

pub fn emit_function(out: &mut String, func: &FunctionDef) {
    for ov in &func.overloads {
        writeln!(out, "---@overload {}", ov).unwrap();
    }
    for param in &func.params {
        if param.name != "..." {
            let opt_str = if param.optional { "?" } else { "" };
            writeln!(out, "---@param {}{} {}", param.name, opt_str, param.ty).unwrap();
        }
    }
    for ret in &func.returns {
        writeln!(out, "---@return {}", ret).unwrap();
    }

    let params_str = func
        .params
        .iter()
        .map(|p| p.name.as_str())
        .collect::<Vec<_>>()
        .join(", ");

    writeln!(out, "function {}({}) end\n", func.name, params_str).unwrap();
}
