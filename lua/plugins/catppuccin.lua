local function catppuccin()
  vim.cmd('colorscheme catppuccin-latte')
  -- vim.cmd('colorscheme catppuccin-macchiato')
end 

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = catppuccin,
}
