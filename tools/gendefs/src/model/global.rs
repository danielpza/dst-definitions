use crate::model::class::ParamDef;

#[derive(Debug, Clone)]
pub struct GlobalDef {
    pub name: String,
    pub ty: String,
    pub entries: Option<Vec<String>>,
}

#[derive(Debug, Clone)]
pub struct FunctionDef {
    pub name: String,
    pub params: Vec<ParamDef>,
    pub returns: Vec<String>,
    pub overloads: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct AliasDef {
    pub name: String,
    pub target: String,
}

#[derive(Debug, Clone)]
pub struct ConstantDef {
    pub name: String,
    pub value: String,
    pub ty: Option<String>,
}

#[derive(Debug, Clone)]
pub struct EnumField {
    pub key: String,
    pub value: String,
}

#[derive(Debug, Clone)]
pub struct EnumDef {
    pub name: String,
    pub enum_type: Option<String>,
    pub fields: Vec<EnumField>,
}

