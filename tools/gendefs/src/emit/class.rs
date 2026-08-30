use std::fmt::Write;

use crate::model::ClassDef;

pub fn emit_class(out: &mut String, class: &ClassDef) {
    if !class.is_extension {
        // ---@class ds.widget: ds.parent
        if let Some(parent) = &class.parent_class_name {
            writeln!(out, "---@class {}: {}", class.class_name, parent).unwrap();
        } else {
            writeln!(out, "---@class {}", class.class_name).unwrap();
        }

        // ---@field name type
        for field in class.fields.values() {
            let opt_str = if field.optional { "?" } else { "" };
            writeln!(out, "---@field {}{} {}", field.name, opt_str, field.ty).unwrap();
        }

        // Custom constructor overloads if specified, otherwise generated signature
        if !class.ctor_overloads.is_empty() {
            for ov in &class.ctor_overloads {
                writeln!(out, "---@overload {}", ov).unwrap();
            }
        } else if !class.ctor_params.is_empty() {
            // ---@overload fun(params): class_name
            let ctor_sig = class
                .ctor_params
                .iter()
                .map(|p| format!("{}?: {}", p.name, p.ty))
                .collect::<Vec<_>>()
                .join(", ");
            writeln!(out, "---@overload fun({}): {}", ctor_sig, class.class_name).unwrap();
        }

        if !class.ctor_params.is_empty() {
            let ctor_args = class
                .ctor_params
                .iter()
                .map(|p| p.name.as_str())
                .collect::<Vec<_>>()
                .join(", ");
            writeln!(
                out,
                "local {} = function({}) end\n",
                class.lua_name, ctor_args
            )
            .unwrap();
        } else if !class.lua_name.is_empty() {
            writeln!(out, "local {} = {{}}\n", class.lua_name).unwrap();
        } else {
            writeln!(out).unwrap();
        }
    } else if !class.lua_name.is_empty() {
        writeln!(out, "local {} = {{}}\n", class.lua_name).unwrap();
    }

    // Methods
    for method in &class.methods {
        for ov in &method.overloads {
            writeln!(out, "---@overload {}", ov).unwrap();
        }
        for param in &method.params {
            if param.name != "..." {
                let opt_str = if param.optional { "?" } else { "" };
                writeln!(out, "---@param {}{} {}", param.name, opt_str, param.ty).unwrap();
            }
        }
        for ret in &method.returns {
            writeln!(out, "---@return {}", ret).unwrap();
        }

        let params_str = method
            .params
            .iter()
            .map(|p| p.name.as_str())
            .collect::<Vec<_>>()
            .join(", ");

        let sep = if method.is_colon { ":" } else { "." };
        writeln!(
            out,
            "function {}{}{}({}) end\n",
            class.lua_name, sep, method.name, params_str
        )
        .unwrap();
    }
}
