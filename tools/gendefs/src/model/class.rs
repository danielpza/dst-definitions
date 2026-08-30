use indexmap::IndexMap;

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct ClassDef {
    pub lua_name: String,
    pub class_name: String,
    pub base_local: Option<String>,
    pub parent_class_name: Option<String>,
    pub ctor_params: Vec<ParamDef>,
    pub ctor_overloads: Vec<String>,
    pub fields: IndexMap<String, FieldDef>,
    pub methods: Vec<MethodDef>,
    pub is_extension: bool,
}

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct FieldDef {
    pub name: String,
    pub ty: String,
    pub optional: bool,
}

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct MethodDef {
    pub name: String,
    pub is_colon: bool,
    pub params: Vec<ParamDef>,
    pub returns: Vec<String>,
    pub overloads: Vec<String>,
}

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct ParamDef {
    pub name: String,
    pub ty: String,
    pub optional: bool,
}
