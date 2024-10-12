local function nvim_treesitter_context()
  require('treesitter-context').setup({
    enable = true,
    max_lines = 3,
  })
end

return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'BufRead',
  config = nvim_treesitter_context,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}
