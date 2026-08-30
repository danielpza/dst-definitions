# dst-definitions

Static type definition files (`---@meta`) for Don't Starve Together (DST) scripts, formatted for [LuaLS](https://luals.github.io/) (Lua Language Server) integration.

> [!IMPORTANT]
> AI was heavily used in this project.
>
> Large portions of the tooling, heuristics, codebase, and type definitions are AI-assisted or AI-generated. Discrepancies, hallucinations, or inaccuracies can and will exist. PRs and fixes are welcome.

## Setup & Installation

To use these definitions in your DST mod or Lua project:

1. Copy or clone the `definitions/` directory into your project (or add this repository as a git submodule).
2. Configure your `.luarc.json` file in the root of your project:

```json
{
  "$schema": "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
  "workspace": {
    "library": ["./dst-definitions/definitions/"]
  },
  "completion": {
    "requireSeparator": "/"
  }
}
```

> Adjust the path `./dst-definitions/definitions/` to point wherever you placed the `definitions/` folder.

## Contributing

This project uses [mise](https://mise.jdx.dev/) for task running and toolchain management.

### Common Tasks

| Command                            | Description                                                                       |
| ---------------------------------- | --------------------------------------------------------------------------------- |
| `mise run generate`                | Run `gendefs` to generate definitions from `gendefs.toml` and format via `stylua` |
| `mise run lua:check`               | Run `lua-language-server --check .` to type-check definition files                |
| `mise run rust:check`              | Run Clippy checks on the `gendefs` generator tool                                 |
| `mise run extract`                 | Extract original game scripts from local DST Steam installation                   |
| `mise exec -- stylua definitions/` | Format all definitions with Stylua                                                |

## Generator (`gendefs`)

`gendefs` is a Rust-based tool that parses Lua 5.1 AST, extracts classes, fields, methods, actions, and constants, and infers LuaLS annotations.

For detailed documentation on configuration, inference rules, and CLI arguments, see [`tools/gendefs/README.md`](tools/gendefs/README.md).

## Manual Overrides

To prevent `gendefs` from overwriting custom or hand-curated definition files, add `-- @manual` as a top-level comment at the top of the file in `definitions/scripts/`.
