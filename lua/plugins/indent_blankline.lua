local function indent_blankline()
  require('ibl').setup({
    indent = { char = '|' },
  })
  vim.opt.listchars:append 'space:⋅'
  vim.opt.listchars:append 'eol:↴'
end

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'BufRead',
  config = indent_blankline,
}
