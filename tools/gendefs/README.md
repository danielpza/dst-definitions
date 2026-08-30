# gendefs

A static analysis tool that parses Don't Starve Together (DST) Lua 5.1 scripts and generates [LuaLS](https://luals.github.io/) definition files (`---@meta`).

## How It Works

```
dst-scripts-original/scripts/
       │
       ▼
 1. full-moon (Lua 5.1 AST)
       │
       ▼
 2. Config-driven Naming & Resolver (`rules.toml`)
       - Normalizes namespaces (e.g. `widgets/button.lua` -> `ds.widgets.button`, `components/container_replica.lua` -> `ds.replicas.container`)
       - Resolves base classes via `local X = require "path"`
       │
       ▼
 3. Extractor Plugin Pipeline (`plugins::*`)
       - RequiresPlugin: Extracts local/global require statements
       - ClassesPlugin: Extracts `Class(...)` constructors & fields
       - ActionsPlugin: Extracts global tables/enums like `ACTIONS = { ... }`
       - ConstantsPlugin: Extracts constants, enums, aliases, and functions from `constants.lua`
       - FunctionsPlugin: Extracts global functions and mod environment functions (`modutil.lua`, `main.lua`, `mainfunctions.lua`, `simutil.lua`)
       - MethodsPlugin: Collects top-level `function Class:Method(...)` in source order
       │
       ▼
 4. Semantic Type Inference (`infer::*` & `rules.toml`)
       - Evaluates literals, binary/unary ops, and known return types
       - Configurable parameter heuristics via `exact`, `suffixes`, and `prefixes`
       - Known method return mappings (e.g. `GetPosition` -> `ds.vector3`)
       │
       ▼
 5. LuaLS Definition Emission (`emit::*`)
       - Writes `---@meta`, `---@class`, `---@field`, `---@overload`, globals, and method stubs
       - Passes output through `stylua` for canonical Lua 5.1 formatting
```

## Configuration

`gendefs` uses a layered configuration approach:
1. **Tool Defaults (`tools/gendefs/gendefs.toml` & embedded fallback):** Defines general naming rules, parameter heuristics, and call return mappings. The default target file list is empty.
2. **Project Configuration (`gendefs.toml` in repository root):** The user specifies target file patterns and any project-specific overrides.

When running, `gendefs` automatically loads base rules and merges the root `gendefs.toml` on top.

### Example Project Configuration (`gendefs.toml`)

```toml
[generate]
src = "dst-scripts-original/scripts"
out = "definitions/scripts"
files = [
    # Global & utility modules
    "actions.lua",
    "constants.lua",
    "events.lua",
    "vector3.lua",

    # Directories (matches all files inside)
    "components/",
    "widgets/",

    # Glob patterns
    "screens/**/*.lua",

    # Negation / exclusions
    "!widgets/ignored.lua",
]
```

### Supported Pattern Syntax in `files`
- `"."` or `"**"` — process all files in `dst-scripts-original/scripts/`
- `"widgets/"` or `"widgets"` — match all scripts in a directory
- `"widgets/button.lua"` — match exact file
- `"widgets/*.lua"` or `"**/*.lua"` — glob pattern match
- `"!path/to/file.lua"` — exclude / blacklist pattern

### Full Configuration Schema (`tools/gendefs/gendefs.toml`)

#### `[generate]` — Target File Patterns & Locations
Specifies source/output paths and script patterns to scan and generate definitions for:
```toml
[generate]
src = "dst-scripts-original/scripts" # or input / source / src_dir
out = "definitions/scripts"         # or output / dest / destination / out_dir
files = []
```

#### `[plugins.naming]` — Namespace & Class Mapping
Maps file paths to LuaLS class namespaces:
```toml
[plugins.naming]
# Exact module path to full class name mapping
special_classes = { "vector3" = "ds.vector3" }

# Prefix-based namespace rules
prefix_rules = [
   { prefix = "components/", target_namespace = "ds.components", replica_suffix = "_replica", replica_namespace = "ds.replicas" },
]

# Fallback root namespace (defaults to "ds")
default_namespace = "ds"
```

#### `[plugins.constants]` — Constants, Enums & Type Aliases
Configures target files, property allowlist, glob/wildcard patterns, type aliases, and enum annotations:
```toml
[plugins.constants]
files = ["constants.lua"]
allowlist = [
    "PI", "PI2", "DEGREES", "RADIANS", "FRAMES", "TILE_SCALE",
    "ANCHOR_MIDDLE", "ANCHOR_LEFT", "ANCHOR_RIGHT", "ANCHOR_TOP", "ANCHOR_BOTTOM",
    "EQUIPSLOTS",
]
patterns = ["CONTROL_*", "KEY_*"]

[plugins.constants.aliases]
"ds.hanchor" = "`ANCHOR_MIDDLE` | `ANCHOR_LEFT` | `ANCHOR_RIGHT`"
"ds.vanchor" = "`ANCHOR_MIDDLE` | `ANCHOR_TOP` | `ANCHOR_BOTTOM`"

[plugins.constants.enums]
EQUIPSLOTS = "ds.equipslot"
DEPLOYMODE = "ds.deploymode"
DEPLOYSPACING = "ds.deployspacing"
SEASONS = "ds.seasons"
MATERIALS = "ds.materials"
```

#### `[plugins.functions]` — Global & Environment Function Extraction
Configures target files and environment export functions (e.g. `env.*` in mod utility scripts):
```toml
[plugins.functions]
files = ["modutil.lua", "main.lua", "simutil.lua", "mainfunctions.lua"]

[plugins.functions.env_exporters."modutil.lua"]
env_var = "env"
functions = ["InsertPostInitFunctions"]
```

#### `[plugins.entity_replica]` — Replica Component Class Generation
Configures replica table extraction and extension class stubs:
```toml
[plugins.entity_replica."entityreplica.lua"]
table = "REPLICATABLE_COMPONENTS"
class_name = "ds.entityreplica"
field_namespace = "ds.replicas"
extend_class = "ds.entityscript"
```

#### `[plugins.actions]` — Action Table Extraction
Configures global action dictionary extraction:
```toml
[plugins.actions."actions.lua"]
global_name = "ACTIONS"
value_type = "ds.actions.action"
```

#### `[plugins.prefabs]` — Prefab Entity Extraction
Configures singleton prefab extractors (`ThePlayer`, `TheWorld`):
```toml
[plugins.prefabs."prefabs/player_common.lua"]
lua_name = "ThePlayer"
class_name = "ds.prefabs.player_common"
parent_class = "ds.entityscript"
target_names = ["inst", "ThePlayer", "player"]
receiver_names = ["self", "inst", "player"]
default_fields = { HUD = "any?", player_classified = "ds.entityscript?", userid = "string" }
```

#### `[plugins.inference]` — Parameter, Identifier & Call Type Heuristics
Infers method/constructor parameter types, global identifiers, and call return values:
```toml
[plugins.inference.identifiers]
Vector3 = "ds.vector3"

[plugins.inference.passthrough_calls]
AddChild = 0

[plugins.inference.params.exact]
# Exact parameter name matches
dt = "number"
time = "number"
text = "string"
enabled = "boolean"
inst = "ds.entityscript"
pos = "number|ds.vector3"
anchor = "ds.vanchor|ds.hanchor"

[plugins.inference.params.suffixes]
# Matches parameter names ending with these suffixes
fn = "function"
cb = "function"
callback = "function"

[plugins.inference.params.prefixes]
# Matches parameter names starting with these prefixes
on_ = "function"

[plugins.inference.calls.returns]
GetPosition = "ds.vector3"
GetWorldPosition = "ds.vector3"
GetLocalPosition = "ds.vector3"
GetScale = "ds.vector3"
GetWorldScale = "ds.vector3"

[plugins.inference.patterns]
"ds.components.*.item" = "ds.entityscript"
"ds.components.*.target" = "ds.entityscript"
"ds.components.*.doer" = "ds.entityscript"
"ds.widgets.*.parent" = "ds.widgets.widget"
```

#### `[overrides.classes]` — Class & Method Overrides
Explicit overrides for fields, inheritance, and method signatures:
```toml
[overrides.classes."ds.components.container"]
super = "ds.entityscript"
fields = { "slots" = "table<integer, ds.entityscript>", "numslots" = "integer" }

[overrides.classes."ds.components.container".methods."GiveItem"]
params = { item = "ds.entityscript", slot = "integer?", drop_on_fail = "boolean?" }
return = "boolean"

[overrides.classes."ds.components.container".methods."DropEverythingByFilter"]
params = { filterfn = "fun(item: ds.entityscript): boolean" }

[overrides.classes."ds.widgets.widget".methods."SetPosition"]
overloads = [
    "fun(pos: ds.vector3)",
    "fun(x: number, y: number, z?: number)"
]
```

#### `[overrides.globals.functions]` — Global Function Overrides
Overrides for global functions:
```toml
[overrides.globals.functions."SpawnPrefab"]
params = { prefab = "string", skin = "string?", skin_id = "integer?", creator = "ds.entityscript?" }
return = "ds.entityscript"
```

---

## Manual File Protection

Files containing the `-- @manual` marker in their header (e.g. `definitions/scripts/widgets/widget.lua`) are skipped and will never be overwritten.

## Usage

### Via mise (recommended)

Runs `gendefs` using the root `gendefs.toml` and formats the output:

```bash
mise run generate
```

### Direct CLI

```bash
# Generate using gendefs.toml defaults
cargo run --manifest-path tools/gendefs/Cargo.toml

# Use a custom configuration file
cargo run --manifest-path tools/gendefs/Cargo.toml -- --config custom.toml

# Generate a specific module or folder
cargo run --manifest-path tools/gendefs/Cargo.toml -- --include widgets/button.lua
cargo run --manifest-path tools/gendefs/Cargo.toml -- --only widgets

# Dry run (log intended writes without modifying files)
cargo run --manifest-path tools/gendefs/Cargo.toml -- --dry-run

# Clean output folder before generating (preserves files tagged with @manual)
cargo run --manifest-path tools/gendefs/Cargo.toml -- --clean
```

## Running Tests

```bash
cargo test --manifest-path tools/gendefs/Cargo.toml
```
