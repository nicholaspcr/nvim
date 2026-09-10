# Nicholas' nvim config

A lazy.nvim-based Neovim configuration. Originally inspired by
[dope](https://github.com/nvimdev/dope).

## Dependencies

Required:

- Neovim 0.12+
- [ripgrep](https://github.com/BurntSushi/ripgrep) — live grep, obsidian search
- [fd](https://github.com/sharkdp/fd) — recent-notes picker
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) ≥ 0.26 — parser installation (`brew install tree-sitter-cli`)
- A C compiler and `make` — parser compilation and telescope-fzf-native

Optional formatters. conform.nvim falls back to LSP formatting for any of
these that is missing, so none of them is required:

- `gofmt` — Go (imports are organised by the gopls code action, no tool needed)
- `rustfmt` — Rust (ships with the toolchain)
- `stylua` — Lua, uses the `.stylua.toml` in this repo. Also required by the
  Checks section below and by CI.
- `prettier` — json, jsonc, yaml, markdown
- `shfmt` — sh, bash

## Layout

```
init.lua                     leader key, core module loading order
lua/core/
  options.lua                editor options (clipboard, folds, search, ...)
  mappings.lua               plugin-independent keymaps
  keymap.lua                 small keymap.set wrapper
  lsp.lua                    capabilities + LspAttach keymaps
  diagnostics.lua            diagnostic rendering
  incremental_selection.lua  <C-space>/<BS> treesitter selection
  theme.lua                  follows the terminal light/dark state file
  lazy.lua                   lazy.nvim bootstrap
lua/lsp/                     one module of settings per language server
lua/plugins/                 one spec per plugin (keymaps live with their plugin)
after/ftplugin/              per-filetype deltas from the global options
plugin/trimwhite.lua         :TrimTrailingWhitespace with inccommand preview
scripts/smoke.lua            headless config sanity check (also run in CI)
```

## Notable behavior

- Leader is `<Space>`; which-key shows group labels, individual descriptions
  come from each mapping's `desc`.
- LSP servers are installed by mason / mason-lspconfig
  (`lua/plugins/mason.lua`). mason-lspconfig v2 enables them itself, so the
  config only supplies per-server settings from `lua/lsp/<server>.lua` via
  `vim.lsp.config()` — which takes precedence over the `lsp/<server>.lua`
  files nvim-lspconfig puts on the runtimepath.
- pylsp expects `python-lsp-black`, `pylsp-mypy`, `pyls-isort`, and `pylint`
  installed in its mason venv.
- Formatting is owned by conform.nvim (`lua/plugins/conform.lua`): `<Leader>fw`
  formats on demand in any buffer, and Go and Rust format on save.
- Notes workflow uses [obsidian.nvim (community fork)](https://github.com/obsidian-nvim/obsidian.nvim)
  with a vault at `~/notes`. Note keymaps live under `<Leader>o` (which also
  holds `<Leader>oz` Zen Mode); `<Leader>ch` toggles a checkbox.
- Markdown buffers get an in-place rendered view via
  [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim);
  `<Leader>tm` swaps between rendered and raw source.
- Treesitter (main rewrite) has no auto-install: parsers are pre-listed in
  `lua/plugins/nvim_treesitter.lua`. Startup only installs what is missing;
  `:TSEnsureInstalled` re-checks the list on demand.
- LSP navigation is `gd`, `gD`, `gi` and `gR` (references). `gR` rather than
  `gr`, which would be a prefix of Neovim's builtin `grn`/`gra`/`grr`/`gri`
  and stall for `timeoutlen` on every press.
- `<Leader>ff` finds files, `<Leader>fh` finds them including hidden and
  gitignored paths (this repo lives under `.config/`, which `<Leader>ff` skips).
- `NVIM_COLUMN` overrides `textwidth` (defaults to 120); `colorcolumn` tracks it.
- Clipboard uses pbcopy/pbpaste on macOS and OSC52 elsewhere (works over SSH).
- `lazy-lock.json` is committed. Use `:Lazy restore` to pin a machine to it and
  `:Lazy update` to move it forward.

## Checks

```sh
stylua --check .
nvim --headless -c 'luafile scripts/smoke.lua' -c 'qa'
```

Both run in CI on every push and pull request to `master`.
