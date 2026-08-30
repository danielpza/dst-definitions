use indexmap::IndexMap;

use super::class::ClassDef;
use super::global::{AliasDef, ConstantDef, EnumDef, FunctionDef, GlobalDef};

#[derive(Debug, Clone)]
pub struct Unit {
    pub rel_path: String,
    pub requires: IndexMap<String, String>, // Local variable name -> require path (e.g., "Widget" -> "widgets/widget")
    pub classes: Vec<ClassDef>,
    pub globals: Vec<GlobalDef>,
    pub functions: Vec<FunctionDef>,
    pub aliases: Vec<AliasDef>,
    pub constants: Vec<ConstantDef>,
    pub enums: Vec<EnumDef>,
}

impl Unit {
    pub fn new(rel_path: String) -> Self {
        Self {
            rel_path,
            requires: IndexMap::new(),
            classes: Vec::new(),
            globals: Vec::new(),
            functions: Vec::new(),
            aliases: Vec::new(),
            constants: Vec::new(),
            enums: Vec::new(),
        }
    }

    pub fn is_empty(&self) -> bool {
        self.classes.is_empty()
            && self.globals.is_empty()
            && self.functions.is_empty()
            && self.aliases.is_empty()
            && self.constants.is_empty()
            && self.enums.is_empty()
    }
}

