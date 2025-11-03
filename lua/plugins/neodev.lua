return {
  'folke/neodev.nvim',
  ft = 'lua',
  config = function()
    require('neodev').setup({
      library = {
        plugins = { 'nvim-dap-ui' },
        types = true,
      },
    })
  end,
}
