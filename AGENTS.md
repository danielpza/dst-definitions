# Agent & Developer Guide (`dst-definitions`)

LuaLS definition files (`---@meta`) for Don't Starve Together (DST) scripts.

---

## Architecture & Layout

- `definitions/` — LuaLS definition files (`---@meta`):
  - `definitions/scripts/` — Generated definition files matching the game script layout. **DO NOT edit manually.**
  - `definitions/dst.lua` — DST modding API globals (`AddComponentPostInit`, `GLOBAL`, `SendModRPCToServer`, etc.).
- `dst-scripts-original/scripts/` — Original DST game scripts extracted from Steam (`mise run extract`). **Always the source of truth.**
- `gendefs.toml` — Project generation whitelist/patterns and overrides.
- `tools/gendefs/` — Rust CLI generator (`gendefs`) that parses Lua 5.1 AST and emits LuaLS definitions.
- `tools/gendefs/gendefs.toml` — Default type inference heuristics, naming rules, and return mappings.

---

## Type Conventions & Annotations

1. **File Headers & Generation Policy:**
   - Every file must start with `---@meta`.
   - Add `---@diagnostic disable: unused-local, missing-return` when stub function bodies are present.
   - **Never manually edit files in `definitions/scripts/`.** If definitions have issues or type inaccuracies, solve them by updating `gendefs.toml` configuration or modifying the `gendefs` Rust generator engine itself.
   - Files marked with `-- @manual` are legacy/hand-written exceptions that `gendefs` skips, but new/updated definitions should be driven by the generator.

2. **Class & Namespace Naming:**
   - Base classes: `ds.entityscript`, `ds.entityreplica`, `ds.widgets.widget`
   - Server components: `ds.components.<name>` (e.g., `components/container.lua` -> `ds.components.container`)
   - Replica components: `ds.replicas.<name>` (e.g., `components/container_replica.lua` -> `ds.replicas.container`)
   - Prefabs / singleton entities: `ds.prefabs.<name>` (e.g., `prefabs/player_common.lua` -> `ds.prefabs.player_common`, `prefabs/world.lua` -> `ds.prefabs.world`)
   - Widgets: `ds.widgets.<name>` (inherit via `---@class ds.widgets.<name>: ds.widgets.widget`)
   - Shared/primitive types: `ds.<name>` (e.g., `ds.vector3`, `ds.hanchor`, `ds.vanchor`)

3. **Constructor Pattern:**
   Use the class overload pattern for constructors rather than separate function stubs:

   ```lua
   ---@class ds.widgets.widget
   ---@field name string
   ---@field parent? ds.widgets.widget
   ---@overload fun(name?: string): ds.widgets.widget
   local Widget = {}
   ```

4. **Fields & Methods:**
   - Type every field assigned on `self` in the constructor as `---@field`. Use `?` for optional/nullable fields.
   - Keep methods in the exact source order to maintain clean diffability against `dst-scripts-original/`.
   - Reuse shared `ds.*` types (e.g., `ds.replicas.inventory`, `EventHandler` from `events.lua`).

5. **Code Style & Formatting:**
   - Stylua config: Lua 5.1, 3-space indentation, `collapse_simple_statement = "Always"`.
   - Run `mise run generate` or `mise exec -- stylua definitions/`. Stylua parsing serves as syntax verification.

---

## Type Overrides & Customizations (`gendefs.toml`)

`gendefs` handles ~80% of definitions automatically. For edge cases, configure overrides in root `gendefs.toml` instead of manually editing generated files.

See [`tools/gendefs/README.md`](tools/gendefs/README.md) for configuration schema and examples (`[plugins.naming]`, `[plugins.prefabs]`, `[plugins.functions]`, `[plugins.constants]`, `[plugins.entity_replica]`, `[plugins.actions]`, `[plugins.inference]`, `[overrides.classes]`, `[overrides.globals]`, etc.).

### Resolution Order

Types are resolved in the following priority:

1. Explicit Class Method Override (`[overrides.classes."...".methods."..."]`)
2. Contextual Pattern Rule (`[plugins.inference.patterns]`)
3. Global Exact Param / Call Return Match (`[plugins.inference.params.exact]`, `[plugins.inference.calls.returns]`)
4. Global Param Suffix / Prefix (`[plugins.inference.params.suffixes]`, `[plugins.inference.params.prefixes]`)
5. AST Type Inference (`full_moon` expression analysis)
6. Fallback (`any`)

---

## Step-by-Step Workflow for Adding/Updating Definitions

1. **Target Identification:**
   Add target relative script path or directory to `gendefs.toml` under `[generate.files]` (e.g. `"widgets/button.lua"` or `"components/"`).
2. **Run Generator:**
   ```bash
   mise run generate
   ```
   Or target a single file directly via `cargo run --manifest-path tools/gendefs/Cargo.toml -- --include <path>`.
3. **Validate Types & Diagnostics:**
   ```bash
   mise run lua:check
   ```
   Ensure no undefined types, syntax errors, or LuaLS diagnostic failures remain.
4. **Refining & Fixing Issues (Never Edit `definitions/scripts/` Manually):**
   - If complex types, fields, or method signatures are inaccurate or missing, configure overrides in root `gendefs.toml` or enhance the `gendefs` Rust generator in `tools/gendefs/`.
   - When modifying the `gendefs` engine, **prefer creating tests** (in `tools/gendefs/src/test.rs` via `cargo test --manifest-path tools/gendefs/Cargo.toml`) instead of manually running generate and inspecting the output. Running `mise run generate` and inspecting output files should be the last resort after tests are passing or if stuck.
   - Re-run `mise run generate` only after tests pass or to verify the final end-to-end output.
   - Check function implementations in `dst-scripts-original/scripts/<path>.lua` to resolve ambiguous union types (e.g., `pos: number|ds.vector3`).
5. **Coverage Verification:**
   Verify method parity against the original game script:
   ```bash
   diff -u <(grep -oP '^function \w+:\w+' dst-scripts-original/scripts/<path>.lua | sed 's/function \w+://' | sort) \
           <(grep -oP '^function \w+:\w+' definitions/scripts/<path>.lua | sed 's/function \w+://' | sort)
   ```
6. **Format & Verify Clean State:**
   ```bash
   mise exec -- stylua definitions/
   mise run lua:check
   ```
7. **Keep AGENTS.md Updated:**
   Whenever naming patterns, configuration structures, tools, or architectural conventions are added or modified, update this `AGENTS.md` guide to keep it strictly aligned with the codebase.

---

## Important Gotchas

- **Keep AGENTS.md Up to Date:** Agents working on this repo must update `AGENTS.md` whenever adding new features, changing conventions, or updating configuration structures.
- **Source Over Existing Defs:** Legacy stubs may contain wrong types (e.g., `templates.lua` `sideLabel` was typed `string`, but is `boolean`). Always check `dst-scripts-original/` when in doubt.
- **Ambiguous Parameters:** Methods accepting both vectors or coordinates (e.g., `SetPosition(pos, y, z)`) should be typed `pos: number|ds.vector3`.
