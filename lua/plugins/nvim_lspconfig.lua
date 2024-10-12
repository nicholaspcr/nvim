return {
  'neovim/nvim-lspconfig',
  dependencies = {{'hrsh7th/cmp-nvim-lsp'}, {'folke/neodev.nvim'}, },
  init = function()
    local map = require('core.keymap').map
    map('n', '<Leader>d', vim.diagnostic.open_float)
    map('n', '[d', vim.diagnostic.goto_prev)
    map('n', ']d', vim.diagnostic.goto_next)
    map('n', '<Leader>q', vim.diagnostic.setloclist)
  end,
}
