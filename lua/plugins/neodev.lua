local function neodev()
  require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
  })
end

return {
  'folke/neodev.nvim',
  dependencies = { 'rcarriga/nvim-dap-ui' },
  config = neodev,
}
