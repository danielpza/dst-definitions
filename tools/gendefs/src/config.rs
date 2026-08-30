use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use indexmap::IndexMap;
use serde::{Deserialize, Serialize};

pub const DEFAULT_CONFIG_TOML: &str = include_str!("../gendefs.toml");

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct Config {
    #[serde(default)]
    pub generate: GenerateConfig,
    #[serde(default)]
    pub plugins: PluginsConfig,
    #[serde(default)]
    pub overrides: OverridesConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct PluginsConfig {
    #[serde(default)]
    pub naming: NamingConfig,
    #[serde(default)]
    pub inference: InferenceConfig,
    #[serde(default)]
    pub prefabs: IndexMap<String, PrefabConfig>,
    #[serde(default)]
    pub constants: ConstantsConfig,
    #[serde(default)]
    pub functions: FunctionsPluginConfig,
    #[serde(default)]
    pub entity_replica: IndexMap<String, EntityReplicaPluginConfig>,
    #[serde(default)]
    pub actions: IndexMap<String, ActionsPluginConfig>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct ConstantsConfig {
    #[serde(default)]
    pub files: Vec<String>,
    #[serde(default, alias = "include", alias = "whitelist", alias = "properties")]
    pub allowlist: Vec<String>,
    #[serde(default)]
    pub aliases: IndexMap<String, String>,
    #[serde(default)]
    pub enums: IndexMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct FunctionsPluginConfig {
    #[serde(default)]
    pub files: Vec<String>,
    #[serde(default)]
    pub env_exporters: IndexMap<String, EnvExporterConfig>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnvExporterConfig {
    #[serde(default = "default_env_var")]
    pub env_var: String,
    #[serde(default)]
    pub functions: Vec<String>,
}

fn default_env_var() -> String {
    "env".to_string()
}

impl Default for EnvExporterConfig {
    fn default() -> Self {
        Self {
            env_var: default_env_var(),
            functions: Vec::new(),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct EntityReplicaPluginConfig {
    #[serde(default)]
    pub lua_name: Option<String>,
    #[serde(default)]
    pub table: String,
    #[serde(default)]
    pub class_name: String,
    #[serde(default)]
    pub field_namespace: String,
    #[serde(default)]
    pub extend_class: Option<String>,
    #[serde(default)]
    pub extend_lua_name: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct ActionsPluginConfig {
    #[serde(default)]
    pub global_name: String,
    #[serde(default)]
    pub value_type: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PrefabConfig {
    pub lua_name: String,
    pub class_name: String,
    #[serde(default)]
    pub parent_class: Option<String>,
    #[serde(default)]
    pub component_namespace: Option<String>,
    #[serde(default)]
    pub target_names: Vec<String>,
    #[serde(default)]
    pub receiver_names: Vec<String>,
    #[serde(default)]
    pub default_fields: IndexMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct OverridesConfig {
    #[serde(default)]
    pub classes: IndexMap<String, ClassOverrideConfig>,
    #[serde(default)]
    pub globals: GlobalsConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct InferenceConfig {
    #[serde(default)]
    pub identifiers: IndexMap<String, String>,
    #[serde(default)]
    pub passthrough_calls: IndexMap<String, usize>,
    #[serde(default)]
    pub params: ParamConfig,
    #[serde(default)]
    pub calls: CallsConfig,
    #[serde(default)]
    pub patterns: IndexMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct GenerateConfig {
    #[serde(default, alias = "input", alias = "source", alias = "src_dir")]
    pub src: Option<PathBuf>,
    #[serde(default, alias = "output", alias = "dest", alias = "destination", alias = "out_dir")]
    pub out: Option<PathBuf>,
    #[serde(default, alias = "include", alias = "whitelist")]
    pub files: Vec<String>,
}

impl GenerateConfig {
    pub fn src(&self) -> PathBuf {
        self.src
            .clone()
            .unwrap_or_else(|| PathBuf::from("dst-scripts-original/scripts"))
    }

    pub fn out(&self) -> PathBuf {
        self.out
            .clone()
            .unwrap_or_else(|| PathBuf::from("definitions/scripts"))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NamingConfig {
    #[serde(default)]
    pub special_classes: IndexMap<String, String>,
    #[serde(default)]
    pub prefix_rules: Vec<PrefixRule>,
    #[serde(default = "default_namespace")]
    pub default_namespace: String,
}

impl Default for NamingConfig {
    fn default() -> Self {
        Self {
            special_classes: IndexMap::new(),
            prefix_rules: Vec::new(),
            default_namespace: default_namespace(),
        }
    }
}

fn default_namespace() -> String {
    "ds".to_string()
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PrefixRule {
    pub prefix: String,
    pub target_namespace: String,
    #[serde(default)]
    pub replica_suffix: Option<String>,
    #[serde(default)]
    pub replica_namespace: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct ParamConfig {
    #[serde(default)]
    pub exact: IndexMap<String, String>,
    #[serde(default)]
    pub suffixes: IndexMap<String, String>,
    #[serde(default)]
    pub prefixes: IndexMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct CallsConfig {
    #[serde(default)]
    pub returns: IndexMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct ClassOverrideConfig {
    #[serde(default, alias = "super", alias = "parent")]
    pub super_class: Option<String>,
    #[serde(default)]
    pub fields: IndexMap<String, String>,
    #[serde(default)]
    pub methods: IndexMap<String, MethodOverrideConfig>,
    #[serde(default)]
    pub constructor: Option<MethodOverrideConfig>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct MethodOverrideConfig {
    #[serde(default)]
    pub params: IndexMap<String, String>,
    #[serde(default, alias = "return")]
    pub return_type: Option<String>,
    #[serde(default)]
    pub returns: Vec<String>,
    #[serde(default)]
    pub overloads: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct GlobalsConfig {
    #[serde(default)]
    pub functions: IndexMap<String, MethodOverrideConfig>,
}

impl Config {
    pub fn default_embedded() -> Self {
        toml::from_str(DEFAULT_CONFIG_TOML).expect("Embedded gendefs.toml should be valid TOML")
    }

    pub fn load_file(path: &Path) -> Result<Self> {
        let content = fs::read_to_string(path)
            .with_context(|| format!("Failed to read config file {}", path.display()))?;
        let config: Self = toml::from_str(&content)
            .with_context(|| format!("Failed to parse config TOML from {}", path.display()))?;
        Ok(config)
    }

    pub fn merge(&mut self, other: Config) {
        if let Some(src) = other.generate.src {
            self.generate.src = Some(src);
        }
        if let Some(out) = other.generate.out {
            self.generate.out = Some(out);
        }
        if !other.generate.files.is_empty() {
            self.generate.files = other.generate.files;
        }
        self.plugins
            .naming
            .special_classes
            .extend(other.plugins.naming.special_classes);
        if !other.plugins.naming.prefix_rules.is_empty() {
            self.plugins.naming.prefix_rules = other.plugins.naming.prefix_rules;
        }
        self.plugins
            .inference
            .identifiers
            .extend(other.plugins.inference.identifiers);
        self.plugins
            .inference
            .passthrough_calls
            .extend(other.plugins.inference.passthrough_calls);
        self.plugins
            .inference
            .params
            .exact
            .extend(other.plugins.inference.params.exact);
        self.plugins
            .inference
            .params
            .suffixes
            .extend(other.plugins.inference.params.suffixes);
        self.plugins
            .inference
            .params
            .prefixes
            .extend(other.plugins.inference.params.prefixes);
        self.plugins
            .inference
            .calls
            .returns
            .extend(other.plugins.inference.calls.returns);
        self.plugins
            .inference
            .patterns
            .extend(other.plugins.inference.patterns);
        self.plugins.prefabs.extend(other.plugins.prefabs);
        if !other.plugins.constants.files.is_empty() {
            self.plugins.constants.files = other.plugins.constants.files;
        }
        if !other.plugins.constants.allowlist.is_empty() {
            self.plugins.constants.allowlist = other.plugins.constants.allowlist;
        }
        self.plugins
            .constants
            .aliases
            .extend(other.plugins.constants.aliases);
        self.plugins
            .constants
            .enums
            .extend(other.plugins.constants.enums);
        if !other.plugins.functions.files.is_empty() {
            self.plugins.functions.files = other.plugins.functions.files;
        }
        self.plugins
            .functions
            .env_exporters
            .extend(other.plugins.functions.env_exporters);
        for (path, replica_cfg) in other.plugins.entity_replica {
            let entry = self.plugins.entity_replica.entry(path).or_default();
            if replica_cfg.lua_name.is_some() {
                entry.lua_name = replica_cfg.lua_name;
            }
            if !replica_cfg.table.is_empty() {
                entry.table = replica_cfg.table;
            }
            if !replica_cfg.class_name.is_empty() {
                entry.class_name = replica_cfg.class_name;
            }
            if !replica_cfg.field_namespace.is_empty() {
                entry.field_namespace = replica_cfg.field_namespace;
            }
            if replica_cfg.extend_class.is_some() {
                entry.extend_class = replica_cfg.extend_class;
            }
            if replica_cfg.extend_lua_name.is_some() {
                entry.extend_lua_name = replica_cfg.extend_lua_name;
            }
        }
        self.plugins.actions.extend(other.plugins.actions);

        // Deep merge class overrides
        for (class_name, other_class_cfg) in other.overrides.classes {
            let entry = self.overrides.classes.entry(class_name).or_default();
            if other_class_cfg.super_class.is_some() {
                entry.super_class = other_class_cfg.super_class;
            }
            entry.fields.extend(other_class_cfg.fields);
            if other_class_cfg.constructor.is_some() {
                entry.constructor = other_class_cfg.constructor;
            }
            for (method_name, method_cfg) in other_class_cfg.methods {
                let m_entry = entry.methods.entry(method_name).or_default();
                m_entry.params.extend(method_cfg.params);
                if method_cfg.return_type.is_some() {
                    m_entry.return_type = method_cfg.return_type;
                }
                if !method_cfg.returns.is_empty() {
                    m_entry.returns = method_cfg.returns;
                }
                if !method_cfg.overloads.is_empty() {
                    m_entry.overloads = method_cfg.overloads;
                }
            }
        }

        // Deep merge global overrides
        for (fn_name, fn_cfg) in other.overrides.globals.functions {
            let g_entry = self
                .overrides
                .globals
                .functions
                .entry(fn_name)
                .or_default();
            g_entry.params.extend(fn_cfg.params);
            if fn_cfg.return_type.is_some() {
                g_entry.return_type = fn_cfg.return_type;
            }
            if !fn_cfg.returns.is_empty() {
                g_entry.returns = fn_cfg.returns;
            }
            if !fn_cfg.overloads.is_empty() {
                g_entry.overloads = fn_cfg.overloads;
            }
        }
    }

    pub fn load_or_default(path: Option<&Path>) -> Result<Self> {
        let mut base = Self::default_embedded();

        // 1. Check for tool-level default config file
        let tool_candidates = [
            Path::new("tools/gendefs/gendefs.toml"),
            Path::new("tools/gendefs/.gendefs.toml"),
            Path::new("tools/gendefs/rules.toml"),
        ];
        for tool_cfg_path in tool_candidates {
            if tool_cfg_path.exists()
                && let Ok(tool_cfg) = Self::load_file(tool_cfg_path)
            {
                base.merge(tool_cfg);
                break;
            }
        }

        // 2. Explicit custom config if passed via CLI
        if let Some(p) = path {
            if p.exists() {
                let custom_cfg = Self::load_file(p)?;
                base.merge(custom_cfg);
                return Ok(base);
            } else {
                anyhow::bail!("Config file does not exist: {}", p.display());
            }
        }

        // 3. Check for project root config file (gendefs.toml, .gendefs.toml, rules.toml)
        let root_candidates = [
            Path::new("gendefs.toml"),
            Path::new(".gendefs.toml"),
            Path::new("rules.toml"),
        ];
        for root_cfg_path in root_candidates {
            if root_cfg_path.exists()
                && !tool_candidates.contains(&root_cfg_path)
                && let Ok(root_cfg) = Self::load_file(root_cfg_path)
            {
                base.merge(root_cfg);
                break;
            }
        }

        Ok(base)
    }
}
