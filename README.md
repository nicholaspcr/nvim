# Nicholas' nvim config

A lazy.nvim-based Neovim configuration. Originally inspired by
[dope](https://github.com/nvimdev/dope).

## Dependencies

- Neovim 0.12+ (nightly)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — live grep, obsidian search
- [fd](https://github.com/sharkdp/fd) — recent-notes picker
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) ≥ 0.26 — parser installation (`brew install tree-sitter-cli`)
- A C compiler and `make` — parser compilation and telescope-fzf-native

## Layout

```
init.lua                     leader key, core module loading order
lua/core/
  options.lua                editor options (clipboard, folds, search, ...)
  mappings.lua               plugin-independent keymaps
  keymap.lua                 small keymap.set wrapper
  incremental_selection.lua  <C-space>/<BS> treesitter selection
  lazy.lua                   lazy.nvim bootstrap
lua/plugins/                 one spec per plugin (keymaps live with their plugin)
after/ftplugin/              per-filetype options and format-on-save (go, rust)
plugin/trimwhite.lua         :TrimTrailingWhitespace with inccommand preview
```

## Notable behavior

- Leader is `<Space>`; which-key shows group labels, individual descriptions
  come from each mapping's `desc`.
- LSP servers are managed by mason / mason-lspconfig (`lua/plugins/mason.lua`);
  pylsp expects `python-lsp-black`, `pylsp-mypy`, `pyls-isort`, and `pylint`
  installed in its mason venv.
- Notes workflow uses [obsidian.nvim (community fork)](https://github.com/obsidian-nvim/obsidian.nvim)
  with a vault at `~/notes`; all note keymaps live under `<Leader>o`.
- Treesitter (main rewrite) has no auto-install: parsers are pre-listed in
  `lua/plugins/nvim_treesitter.lua`; add new languages there or via `:TSInstall`.
- `NVIM_COLUMN` overrides `textwidth` (defaults to 120); `colorcolumn` tracks it.
- Clipboard uses pbcopy/pbpaste on macOS and OSC52 elsewhere (works over SSH).
