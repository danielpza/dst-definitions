//! # File and Pattern Filter
//!
//! Handles target file matching supporting:
//! - `"."` or `"**"`: match everything
//! - `"folder/"` or `"folder"`: match entire directories
//! - `"folder/file.lua"`: match exact files
//! - `"*.lua"` or `"**/*.lua"`: glob patterns
//! - `"!pattern"`: negative exclusion patterns

use glob::Pattern;

#[derive(Debug, Clone, Default)]
pub struct FileFilter {
    includes: Vec<String>,
    excludes: Vec<String>,
    glob_includes: Vec<Pattern>,
    glob_excludes: Vec<Pattern>,
}

impl FileFilter {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn with_prefix(mut self, prefix: Option<String>) -> Self {
        if let Some(p) = prefix {
            self.add_pattern(p);
        }
        self
    }

    pub fn add_pattern(&mut self, raw_pattern: impl AsRef<str>) {
        let trimmed = raw_pattern.as_ref().trim();
        if trimmed.is_empty() || trimmed.starts_with('#') {
            return;
        }

        // Support negative patterns like "!widgets/ignored.lua"
        if let Some(negated) = trimmed.strip_prefix('!') {
            let neg_trimmed = negated.trim();
            if !neg_trimmed.is_empty() {
                if is_glob(neg_trimmed)
                    && let Ok(pat) = Pattern::new(neg_trimmed)
                {
                    self.glob_excludes.push(pat);
                }
                self.excludes.push(neg_trimmed.to_string());
            }
            return;
        }

        if is_glob(trimmed)
            && let Ok(pat) = Pattern::new(trimmed)
        {
            self.glob_includes.push(pat);
        }
        self.includes.push(trimmed.to_string());
    }

    pub fn add_patterns<I, S>(&mut self, patterns: I)
    where
        I: IntoIterator<Item = S>,
        S: AsRef<str>,
    {
        for p in patterns {
            self.add_pattern(p);
        }
    }

    pub fn should_process(&self, rel_path: &str) -> bool {
        let normalized = rel_path.replace('\\', "/");

        // 1. Check exclusions first
        for excl in &self.excludes {
            if matches_rule(excl, &normalized) {
                return false;
            }
        }
        for pat in &self.glob_excludes {
            if pat.matches(&normalized) {
                return false;
            }
        }

        // 2. If no include patterns specified, match everything
        if self.includes.is_empty() {
            return true;
        }

        // 3. Match against inclusion rules
        for inc in &self.includes {
            if matches_rule(inc, &normalized) {
                return true;
            }
        }
        for pat in &self.glob_includes {
            if pat.matches(&normalized) {
                return true;
            }
        }

        false
    }
}

fn is_glob(s: &str) -> bool {
    s.contains('*') || s.contains('?') || s.contains('[')
}

fn matches_rule(rule: &str, path: &str) -> bool {
    let clean_rule = rule.trim();

    // 1. "." or "**" matches all files
    if clean_rule == "." || clean_rule == "*" || clean_rule == "**" {
        return true;
    }

    // 2. Exact match (e.g. "widgets/widget.lua")
    if clean_rule == path {
        return true;
    }

    // 3. Trailing slash folder match (e.g. "widgets/" matches "widgets/button.lua")
    if clean_rule.ends_with('/') && path.starts_with(clean_rule) {
        return true;
    }

    // 4. Folder name match without trailing slash (e.g. "widgets" matches "widgets/button.lua")
    if path.starts_with(&format!("{}/", clean_rule.trim_end_matches('/'))) {
        return true;
    }

    false
}
