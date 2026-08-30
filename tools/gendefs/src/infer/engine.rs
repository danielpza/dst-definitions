use full_moon::ast::{
    BinOp, Call, Expression, FunctionArgs, FunctionCall, Prefix, Suffix, UnOp, Var, VarExpression,
};
use indexmap::IndexMap;

use crate::config::Config;
use crate::resolver::NamingResolver;

#[derive(Clone)]
pub struct InferenceEngine<'a> {
    config: &'a Config,
    resolver: &'a NamingResolver,
}

impl<'a> InferenceEngine<'a> {
    pub fn new(config: &'a Config, resolver: &'a NamingResolver) -> Self {
        Self { config, resolver }
    }

    pub fn infer_method_param_type(
        &self,
        class_name: &str,
        method_name: &str,
        param_name: &str,
    ) -> Option<String> {
        // 1. Explicit class method override
        if let Some(class_cfg) = self.config.overrides.classes.get(class_name) {
            if let Some(method_cfg) = class_cfg.methods.get(method_name)
                && let Some(ty) = method_cfg.params.get(param_name)
            {
                return Some(ty.clone());
            }
            if (method_name == "__init" || method_name == "constructor")
                && let Some(ctor_cfg) = &class_cfg.constructor
                && let Some(ty) = ctor_cfg.params.get(param_name)
            {
                return Some(ty.clone());
            }
        }

        // 2. Pattern-based param rules (e.g. "ds.components.*.item" or "ds.widgets.*.parent")
        let full_key = format!("{}.{}", class_name, param_name);
        for (pattern, ty) in &self.config.plugins.inference.patterns {
            if matches_pattern(pattern, &full_key) {
                return Some(ty.clone());
            }
        }

        None
    }

    #[allow(dead_code)]
    pub fn infer_global_param_type(&self, fn_name: &str, param_name: &str) -> Option<String> {
        if let Some(fn_cfg) = self.config.overrides.globals.functions.get(fn_name)
            && let Some(ty) = fn_cfg.params.get(param_name)
        {
            return Some(ty.clone());
        }
        None
    }

    pub fn infer_param_type(&self, name: &str) -> String {
        let lower = name.to_lowercase();
        if let Some(ty) = self.config.plugins.inference.params.exact.get(&lower) {
            return ty.clone();
        }
        for (suffix, ty) in &self.config.plugins.inference.params.suffixes {
            if lower.ends_with(suffix) {
                return ty.clone();
            }
        }
        for (prefix, ty) in &self.config.plugins.inference.params.prefixes {
            if lower.starts_with(prefix) {
                return ty.clone();
            }
        }
        "any".to_string()
    }

    pub fn infer_expr_type(
        &self,
        expr: &Expression,
        requires: &IndexMap<String, String>,
        locals: &IndexMap<String, String>,
    ) -> String {
        match expr {
            Expression::Number(_) => "number".to_string(),
            Expression::String(_) => "string".to_string(),
            Expression::TableConstructor(_) => "table".to_string(),
            Expression::Function(_) => "function".to_string(),
            Expression::Symbol(tok) => {
                let s = tok.token().to_string();
                let trimmed = s.trim();
                if trimmed == "true" || trimmed == "false" {
                    "boolean".to_string()
                } else {
                    "any".to_string()
                }
            }
            Expression::Parentheses { expression, .. } => {
                self.infer_expr_type(expression, requires, locals)
            }
            Expression::Var(var) => match var {
                Var::Name(tok) => {
                    let name = tok.token().to_string().trim().to_string();
                    if let Some(ty) = locals.get(&name) {
                        ty.clone()
                    } else if let Some(ty) = self.config.plugins.inference.identifiers.get(&name) {
                        ty.clone()
                    } else {
                        "any".to_string()
                    }
                }
                Var::Expression(var_expr) => self.infer_var_expression(var_expr, requires, locals),
                _ => "any".to_string(),
            },
            Expression::FunctionCall(func_call) => {
                self.infer_function_call(func_call, requires, locals)
            }
            Expression::BinaryOperator { lhs, binop, rhs } => match binop {
                BinOp::And(_) => self.infer_expr_type(rhs, requires, locals),
                BinOp::Or(_) => {
                    let r = self.infer_expr_type(rhs, requires, locals);
                    if r != "any" {
                        r
                    } else {
                        self.infer_expr_type(lhs, requires, locals)
                    }
                }
                BinOp::TwoDots(_) => "string".to_string(),
                BinOp::Plus(_)
                | BinOp::Minus(_)
                | BinOp::Star(_)
                | BinOp::Slash(_)
                | BinOp::Percent(_)
                | BinOp::Caret(_) => "number".to_string(),
                BinOp::TwoEqual(_)
                | BinOp::TildeEqual(_)
                | BinOp::LessThan(_)
                | BinOp::LessThanEqual(_)
                | BinOp::GreaterThan(_)
                | BinOp::GreaterThanEqual(_) => "boolean".to_string(),
                _ => "any".to_string(),
            },
            Expression::UnaryOperator { unop, expression } => match unop {
                UnOp::Not(_) => "boolean".to_string(),
                UnOp::Minus(_) => "number".to_string(),
                _ => self.infer_expr_type(expression, requires, locals),
            },
            _ => "any".to_string(),
        }
    }

    fn infer_function_call(
        &self,
        func_call: &FunctionCall,
        requires: &IndexMap<String, String>,
        locals: &IndexMap<String, String>,
    ) -> String {
        if let Prefix::Name(name_tok) = func_call.prefix() {
            let name = name_tok.token().to_string().trim().to_string();
            if let Some(ty) = self.config.plugins.inference.identifiers.get(&name) {
                return ty.clone();
            }
            if let Some(req) = requires.get(&name) {
                return self.resolver.class_name_for_require(req);
            }
        }

        for suffix in func_call.suffixes() {
            if let Suffix::Call(Call::MethodCall(method_call)) = suffix {
                let mname = method_call.name().token().to_string().trim().to_string();
                if let Some(&arg_idx) =
                    self.config.plugins.inference.passthrough_calls.get(&mname)
                {
                    if let FunctionArgs::Parentheses { arguments, .. } = method_call.args()
                        && let Some(target_arg) = arguments.iter().nth(arg_idx)
                    {
                        return self.infer_expr_type(target_arg, requires, locals);
                    }
                } else if let Some(ret) = self.config.plugins.inference.calls.returns.get(&mname) {
                    return ret.clone();
                }
            }
        }

        "any".to_string()
    }

    fn infer_var_expression(
        &self,
        var_expr: &VarExpression,
        requires: &IndexMap<String, String>,
        locals: &IndexMap<String, String>,
    ) -> String {
        let prefix = var_expr.prefix();
        let prefix_name = match prefix {
            Prefix::Name(tok) => tok.token().to_string().trim().to_string(),
            _ => String::new(),
        };

        let suffixes: Vec<_> = var_expr.suffixes().collect();
        if suffixes.is_empty() {
            if let Some(ty) = locals.get(&prefix_name) {
                return ty.clone();
            }
            return "any".to_string();
        }

        if !prefix_name.is_empty() {
            if let Some(ty) = self.config.plugins.inference.identifiers.get(&prefix_name) {
                return ty.clone();
            }
            if let Some(req) = requires.get(&prefix_name) {
                return self.resolver.class_name_for_require(req);
            }
        }

        "any".to_string()
    }
}

fn matches_pattern(pattern: &str, target: &str) -> bool {
    if pattern == target {
        return true;
    }
    if let Some(prefix) = pattern.strip_suffix('*') {
        return target.starts_with(prefix);
    }
    if let Some((prefix, suffix)) = pattern.split_once('*') {
        return target.starts_with(prefix) && target.ends_with(suffix);
    }
    false
}
