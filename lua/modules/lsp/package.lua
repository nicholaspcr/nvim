local package = require('core.pack').package
local conf = require('modules.lsp.config')

package({
  'mfussenegger/nvim-dap',
})

package({
  'rcarriga/nvim-dap-ui',
  config = conf.dap_ui,
  dependencies = {
    { 'mfussenegger/nvim-dap' },
    { 'nvim-neotest/nvim-nio' },
  },
})

package({
  'leoluz/nvim-dap-go',
  ft = "go",
  dependencies = { { 'mfussenegger/nvim-dap' } },
  config = conf.nvim_dap_go,
})

package({
  'folke/neodev.nvim',
  config = conf.neodev,
  dependencies = { { 'rcarriga/nvim-dap-ui' } },
})

package({ 'williamboman/mason.nvim' })
package({ 'williamboman/mason-lspconfig.nvim' })
package({ 'neovim/nvim-lspconfig' })

-- The configuration of this package handles both cmp and LSP configs
package({
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  config = conf.nvim_cmp,
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-buffer' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-cmdline' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'folke/neodev.nvim' },
  },
})

package({
  'neovim/nvim-lspconfig',
  config = conf.nvim_lspconfig,
  dependencies = {{'hrsh7th/cmp-nvim-lsp'}, {'folke/neodev.nvim'}, },
  init = function()
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
  end
})

package({
  'L3MON4D3/LuaSnip',
  event = 'InsertCharPre',
  config = conf.lua_snip,
})
