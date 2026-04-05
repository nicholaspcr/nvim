local keymap = {}

keymap.cmd = function(str)
  return '<cmd>' .. str .. '<CR>'
end

keymap.map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return keymap
