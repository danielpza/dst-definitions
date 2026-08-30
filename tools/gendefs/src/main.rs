mod config;
mod emit;
mod filter;
mod infer;
mod model;
mod plugins;
mod resolver;
#[cfg(test)]
mod test;

use anyhow::{Context, Result};
use clap::Parser;
use std::fs;
use std::path::PathBuf;
use walkdir::WalkDir;

use crate::config::Config;
use crate::emit::emit_unit;
use crate::filter::FileFilter;
use crate::infer::InferenceEngine;
use crate::model::Unit;
use crate::plugins::{ExtractContext, PluginRegistry};
use crate::resolver::NamingResolver;

#[derive(Parser, Debug)]
#[command(author, version, about = "Generate LuaLS definitions from DST scripts")]
struct Args {
    /// Path to DST scripts directory (overrides config)
    #[arg(long)]
    src: Option<PathBuf>,

    /// Output directory for definitions (overrides config)
    #[arg(long)]
    out: Option<PathBuf>,

    /// Path to configuration rules TOML file
    #[arg(long)]
    config: Option<PathBuf>,

    /// Filter by prefix (e.g. "widgets" or "components")
    #[arg(long)]
    only: Option<String>,

    /// Path to a whitelist/pattern file (one pattern per line)
    #[arg(long, alias = "whitelist")]
    files_file: Option<PathBuf>,

    /// Explicitly included files/patterns (e.g. "widgets/", "actions.lua")
    #[arg(long = "include", alias = "file")]
    includes: Vec<String>,

    /// Do not write files, just log what would be done
    #[arg(long)]
    dry_run: bool,

    /// Clean output directory before generating (preserves files tagged with @manual)
    #[arg(long)]
    clean: bool,
}

fn clean_output_dir(out: &PathBuf, dry_run: bool) -> Result<(usize, usize)> {
    if !out.exists() {
        return Ok((0, 0));
    }

    let mut removed_count = 0;
    let mut kept_manual_count = 0;

    // First collect all lua files to inspect
    let mut files_to_delete = Vec::new();
    for entry in WalkDir::new(out).into_iter().filter_map(|e| e.ok()) {
        let path = entry.path();
        if path.is_file() {
            if path.extension().and_then(|s| s.to_str()) == Some("lua")
                && let Ok(content) = fs::read_to_string(path)
                && content.contains("@manual")
            {
                kept_manual_count += 1;
                continue;
            }
            files_to_delete.push(path.to_path_buf());
        }
    }

    for file_path in files_to_delete {
        if dry_run {
            println!("[dry-run] Would remove {}", file_path.display());
        } else {
            fs::remove_file(&file_path)
                .with_context(|| format!("Failed to remove file {}", file_path.display()))?;
        }
        removed_count += 1;
    }

    // Clean up empty directories (bottom-up)
    if !dry_run {
        for entry in WalkDir::new(out).contents_first(true).into_iter().filter_map(|e| e.ok()) {
            let path = entry.path();
            if path.is_dir()
                && path != out
                && let Ok(mut read_dir) = fs::read_dir(path)
                && read_dir.next().is_none()
            {
                let _ = fs::remove_dir(path);
            }
        }
    }

    Ok((removed_count, kept_manual_count))
}

fn main() -> Result<()> {
    let args = Args::parse();
    let config = Config::load_or_default(args.config.as_deref())?;
    let src = args.src.unwrap_or_else(|| config.generate.src());
    let out = args.out.unwrap_or_else(|| config.generate.out());

    if !src.exists() {
        anyhow::bail!("Source directory does not exist: {}", src.display());
    }

    if args.clean {
        println!("Cleaning output directory {}...", out.display());
        let (removed, preserved) = clean_output_dir(&out, args.dry_run)?;
        println!(
            "Cleaned output directory: {} files removed ({} preserved with @manual).",
            removed, preserved
        );
    }

    let resolver = NamingResolver::new(config.plugins.naming.clone());
    let infer = InferenceEngine::new(&config, &resolver);
    let plugins = PluginRegistry::default_plugins();

    // Configure pipeline file filter (from CLI flags, files file, or config `[generate.files]`)
    let mut filter = FileFilter::new().with_prefix(args.only);
    filter.add_patterns(args.includes);

    if let Some(files_file) = &args.files_file {
        if files_file.exists() {
            let content = fs::read_to_string(files_file)
                .with_context(|| format!("Failed to read files list {}", files_file.display()))?;
            filter.add_patterns(content.lines());
        }
    } else {
        filter.add_patterns(config.generate.files.clone());
    }

    println!("Scanning scripts in {}...", src.display());

    let mut units: Vec<Unit> = Vec::new();
    let mut scanned_count = 0;
    let mut skipped_filter = 0;
    let mut skipped_no_class = 0;
    let mut parse_errors = 0;

    for entry in WalkDir::new(&src).into_iter().filter_map(|e| e.ok()) {
        let path = entry.path();
        if path.extension().and_then(|s| s.to_str()) != Some("lua") {
            continue;
        }

        scanned_count += 1;
        let rel_path = path
            .strip_prefix(&src)
            .unwrap()
            .to_string_lossy()
            .replace('\\', "/");

        if !filter.should_process(&rel_path) {
            skipped_filter += 1;
            continue;
        }

        let bytes = fs::read(path).with_context(|| format!("Failed to read {}", path.display()))?;
        let content = String::from_utf8_lossy(&bytes);

        let has_plugin_target = config
            .plugins
            .prefabs
            .keys()
            .chain(config.plugins.actions.keys())
            .chain(config.plugins.entity_replica.keys())
            .chain(config.plugins.functions.env_exporters.keys())
            .chain(&config.plugins.functions.files)
            .chain(&config.plugins.constants.files)
            .any(|target| rel_path == *target || rel_path.ends_with(target));

        if !has_plugin_target
            && !content.contains("Class(")
            && !content.contains("function ")
            && !content.contains("function(")
        {
            skipped_no_class += 1;
            continue;
        }

        let ast = match full_moon::parse(&content) {
            Ok(ast) => ast,
            Err(errs) => {
                eprintln!("Warning: Failed to parse {}: {:?}", rel_path, errs);
                parse_errors += 1;
                continue;
            }
        };

        let ctx = ExtractContext {
            ast: &ast,
            rel_path: &rel_path,
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };

        if let Some(unit) = plugins.extract(&ctx) {
            units.push(unit);
        }
    }

    println!(
        "Scanned {} files ({} skipped by filter, {} no class/global, {} parse errors). Extracted {} units.",
        scanned_count,
        skipped_filter,
        skipped_no_class,
        parse_errors,
        units.len()
    );

    println!("Emitting {} units...", units.len());

    let mut emitted_count = 0;
    let mut manual_skipped_count = 0;

    for unit in &units {
        let out_path = out.join(&unit.rel_path);

        // Check for manual protection marker
        if out_path.exists()
            && let Ok(existing) = fs::read_to_string(&out_path)
            && existing.contains("@manual")
        {
            println!("Skipping {} (marked as @manual)", unit.rel_path);
            manual_skipped_count += 1;
            continue;
        }

        let emitted = emit_unit(unit);

        if args.dry_run {
            println!("[dry-run] Would write {}", out_path.display());
        } else {
            if let Some(parent) = out_path.parent() {
                fs::create_dir_all(parent)
                    .with_context(|| format!("Failed to create dir {}", parent.display()))?;
            }
            fs::write(&out_path, &emitted)
                .with_context(|| format!("Failed to write {}", out_path.display()))?;
            emitted_count += 1;
        }
    }

    println!(
        "Done! Emitted {} files ({} skipped as @manual).",
        emitted_count, manual_skipped_count
    );

    Ok(())
}
