-- Per-server settings, one module each. Registered by lua/core/lsp.lua with
-- vim.lsp.config(), which takes precedence over the lsp/<name>.lua files
-- nvim-lspconfig ships on the runtimepath (those provide cmd/filetypes/roots).
return {
  clangd = require('lsp.clangd'),
  gopls = require('lsp.gopls'),
  lua_ls = require('lsp.lua_ls'),
  marksman = require('lsp.marksman'),
  pylsp = require('lsp.pylsp'),
  rust_analyzer = require('lsp.rust_analyzer'),
  ts_ls = require('lsp.ts_ls'),
}
