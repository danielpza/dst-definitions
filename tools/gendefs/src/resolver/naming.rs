use crate::config::NamingConfig;

#[derive(Debug, Clone)]
pub struct NamingResolver {
    config: NamingConfig,
}

impl NamingResolver {
    pub fn new(config: NamingConfig) -> Self {
        Self { config }
    }

    pub fn class_name_for_require(&self, req_path: &str) -> String {
        let clean = req_path.trim_matches(['"', '\'']);
        if let Some(special) = self.config.special_classes.get(clean) {
            return special.clone();
        }

        for rule in &self.config.prefix_rules {
            if clean.starts_with(&rule.prefix) {
                let sub = clean.strip_prefix(&rule.prefix).unwrap();
                if let Some(replica_suffix) = &rule.replica_suffix
                    && let Some(name) = sub.strip_suffix(replica_suffix)
                {
                    let ns = rule
                        .replica_namespace
                        .as_deref()
                        .unwrap_or(&rule.target_namespace);
                    return format!("{}.{}", ns, name.replace('/', "."));
                }
                return format!("{}.{}", rule.target_namespace, sub.replace('/', "."));
            }
        }

        format!("{}.{}", self.config.default_namespace, clean.replace('/', "."))
    }

    pub fn class_name_for_rel_path(&self, rel_path: &str, lua_name: &str) -> String {
        let clean = rel_path.trim_end_matches(".lua");
        if let Some(special) = self.config.special_classes.get(clean) {
            return special.clone();
        }

        for rule in &self.config.prefix_rules {
            if clean.starts_with(&rule.prefix) {
                let sub = clean.strip_prefix(&rule.prefix).unwrap();
                if let Some(replica_suffix) = &rule.replica_suffix
                    && let Some(name) = sub.strip_suffix(replica_suffix)
                {
                    let ns = rule
                        .replica_namespace
                        .as_deref()
                        .unwrap_or(&rule.target_namespace);
                    return format!("{}.{}", ns, name.replace('/', "."));
                }
                return format!("{}.{}", rule.target_namespace, sub.replace('/', "."));
            }
        }

        let base_module = clean.replace('/', ".");
        let last_segment = clean.rsplit('/').next().unwrap_or(clean);
        if !lua_name.is_empty()
            && lua_name.to_lowercase() != base_module.to_lowercase()
            && lua_name.to_lowercase() != last_segment.to_lowercase()
        {
            format!(
                "{}.{}.{}",
                self.config.default_namespace,
                base_module,
                lua_name.to_lowercase()
            )
        } else {
            format!("{}.{}", self.config.default_namespace, base_module)
        }
    }
}
