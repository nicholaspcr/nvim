local function catppuccin()
  vim.cmd('colorscheme catppuccin-mocha')
end 

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = catppuccin,
}
