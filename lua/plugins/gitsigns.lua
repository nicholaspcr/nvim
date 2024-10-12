local function gitsigns()
  require('gitsigns').setup{}
end

return {
  'lewis6991/gitsigns.nvim',
  config = gitsigns,
}
