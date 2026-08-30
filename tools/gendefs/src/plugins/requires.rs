//! # Requires Extractor Plugin
//!
//! ### Purpose
//! Discovers and records all module imports via `require(...)` calls in the top-level block of a Lua file.
//!
//! ### Handled Patterns
//! - `local Widget = require "widgets/widget"`
//! - `local Text = require("widgets/text")`
//! - Top-level global assignments: `Widget = require "widgets/widget"`
//!
//! ### Effect on Unit
//! Populates `unit.requires` with mapping `[local_var_name -> require_path]`, which downstream plugins
//! use for resolving base class inheritance and type inference of external constructor calls.

use full_moon::ast::{Block, Call, Expression, FunctionArgs, Prefix, Stmt, Suffix, Var};

use crate::model::Unit;
use crate::plugins::{ExtractContext, Plugin};

#[derive(Default)]
pub struct RequiresPlugin;

impl Plugin for RequiresPlugin {
    fn name(&self) -> &'static str {
        "requires"
    }

    fn extract(&self, ctx: &ExtractContext, unit: &mut Unit) {
        extract_requires(ctx.ast.nodes(), unit);
    }
}

fn extract_requires(block: &Block, unit: &mut Unit) {
    for stmt in block.stmts() {
        match stmt {
            Stmt::LocalAssignment(local_assign) => {
                for (name_tok, expr) in local_assign
                    .names()
                    .iter()
                    .zip(local_assign.expressions().iter())
                {
                    let local_name = name_tok.token().to_string().trim().to_string();
                    if let Some(req_path) = match_require_call(expr) {
                        unit.requires.insert(local_name, req_path);
                    }
                }
            }
            Stmt::Assignment(assign) => {
                for (var, expr) in assign.variables().iter().zip(assign.expressions().iter()) {
                    if let Var::Name(name_tok) = var {
                        let name = name_tok.token().to_string().trim().to_string();
                        if let Some(req_path) = match_require_call(expr) {
                            unit.requires.insert(name, req_path);
                        }
                    }
                }
            }
            _ => {}
        }
    }
}

fn match_require_call(expr: &Expression) -> Option<String> {
    if let Expression::FunctionCall(func_call) = expr
        && let Prefix::Name(name_tok) = func_call.prefix()
        && name_tok.token().to_string().trim() == "require"
    {
        for suffix in func_call.suffixes() {
            if let Suffix::Call(Call::AnonymousCall(args)) = suffix {
                match args {
                    FunctionArgs::Parentheses { arguments, .. } => {
                        if let Some(Expression::String(s)) = arguments.iter().next() {
                            return Some(
                                s.token()
                                    .to_string()
                                    .trim()
                                    .trim_matches(['"', '\''])
                                    .to_string(),
                            );
                        }
                    }
                    FunctionArgs::String(s) => {
                        return Some(
                            s.token()
                                .to_string()
                                .trim()
                                .trim_matches(['"', '\''])
                                .to_string(),
                        );
                    }
                    _ => {}
                }
            }
        }
    }
    None
}
