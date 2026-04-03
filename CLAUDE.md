# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). The primary entry point is `init.lua` — a single-file config that is intentionally kept readable and documented. Custom additions live in `lua/custom/plugins/`.

## Formatting

All Lua must be formatted with **StyLua** before committing. Config is in `.stylua.toml`:
- 160 column width, 2-space indentation, single quotes, no parentheses on bare calls.

```bash
stylua .         # format all
stylua --check . # check without modifying (used in CI)
```

StyLua is installed via Mason and available at `~/.local/share/nvim/mason/bin/stylua`.

## Architecture

**Plugin management**: lazy.nvim. All plugins are declared inside `require('lazy').setup({...})` in `init.lua`, except custom plugins which are auto-imported from `lua/custom/plugins/*.lua` via `{ import = 'custom.plugins' }`.

**Adding plugins**: Create a new file in `lua/custom/plugins/` returning a lazy.nvim plugin spec. The `init.lua` never needs to change.

**Key layers**:
- `init.lua` — options, keymaps, autocommands, and all core plugins inline
- `lua/custom/plugins/` — personal plugin additions (one file per plugin)
- `lua/kickstart/plugins/` — optional kickstart extras (autopairs, gitsigns enabled; debug/lint/indent_line/neo-tree available but commented out)
- `ftplugin/java.lua` — Java LSP setup via nvim-jdtls (runs on FileType java)

**Core plugins and their roles**:
- **fzf-lua** — fuzzy finder (files, grep, LSP symbols, git, buffers). Leader-s prefix for search, leader-g for git pickers.
- **nvim-lspconfig + mason** — LSP management. Configured servers: `jsonls`, `ruby_lsp` (custom cmd, not Mason-managed), `ts_ls`, `yamlls`, `lemminx`, `lua_ls`.
- **blink.cmp** — completion engine sourcing from LSP, path, and snippets. `<c-y>` to accept, `<c-n>/<c-p>` to navigate.
- **conform.nvim** — autoformat on save. Lua uses stylua; other languages fall back to LSP formatter.
- **snacks.nvim** — utilities: terminal provider for Claude Code, notifications, input UI, scroll, indent guides, zen/dim modes, LSP word navigation.
- **claudecode.nvim** — Claude Code integration, using snacks as terminal provider, opening in a right split (30% width). Leader-a prefix.
- **vim-slime** — send code to a running terminal. `gz{motion}`, `gzz` (line), visual `gz`.
- **nvim-jdtls** — Java LSP via `ftplugin/java.lua`. Requires Java 21+ via sdkman; workspace stored in `~/.cache/nvim/jdtls/workspace/<project>`.

**LSP key bindings** (set on LspAttach):
- `grn` rename, `gra` code action, `grd` definition, `grr` references, `gri` implementation, `grt` type def, `gO` document symbols, `gW` workspace symbols, `grf` format, `<leader>th` toggle inlay hints.

**ruby_lsp** uses a custom bundle at `/Users/ngk86v/Documents/Github/avant-basic/.vscode/ruby-lsp-env` and is not installed via Mason.