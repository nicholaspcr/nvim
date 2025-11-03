local function indent_blankline()
  local ok, ibl = pcall(require, 'ibl')
  if not ok then
    vim.notify("Failed to load indent-blankline", vim.log.levels.ERROR)
    return
  end

  ibl.setup({
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
