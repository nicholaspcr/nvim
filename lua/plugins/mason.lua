-- Mason installs the language servers. Everything else lives next door:
--   lua/lsp/<server>.lua     per-server settings
--   lua/core/lsp.lua         capabilities, inlay hints, organize imports
--   lua/core/diagnostics.lua diagnostic rendering
return {
  'mason-org/mason-lspconfig.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'neovim/nvim-lspconfig',
    'mason-org/mason.nvim',
    -- Loaded here rather than on InsertEnter so vim.lsp.config('*') carries
    -- blink's capabilities before the first client starts.
    'saghen/blink.cmp',
  },
  config = function()
    local servers = require('lsp')

    require('mason').setup()
    require('core.diagnostics').setup()

    -- Registered before mason-lspconfig, which enables servers immediately and
    -- can trigger a FileType pass; a client started in that window would
    -- otherwise come up without these settings.
    require('core.lsp').setup(servers)

    -- mason-lspconfig v2 enables every ensure_installed server itself
    -- (automatic_enable defaults to true), so there are no vim.lsp.enable calls.
    require('mason-lspconfig').setup({
      ensure_installed = vim.tbl_keys(servers),
    })
  end,
}
