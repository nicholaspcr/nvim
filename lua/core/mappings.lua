local keymap = require('core.keymap')
local map = keymap.map
local cmd = keymap.cmd

-- close buffer
map('n', '<C-x>k', cmd('bdelete'), { desc = 'Close buffer' })
map('n', '<C-x>p', cmd('let @+=expand("%:p")'), { desc = 'Copy file path' })

-- save
map('n', '<C-s>', cmd('write'), { desc = 'Save file' })
-- remove trailing white space
map('n', '<Leader>tw', cmd('TrimTrailingWhitespace'), { desc = 'Trim whitespace' })
map('n', '<Leader><CR>', ':noh<CR>', { desc = 'Clear search highlight' })
-- Tab related. bufferline runs in 'tabs' mode so the bar tracks these; the
-- builtin gt / gT already walk tab pages, and ]t / [t are the builtin tag
-- motions, so neither is remapped here.
map('n', '<Leader>tn', cmd('tabnew'), { desc = 'New tab' })
map('n', '<Leader>tc', cmd('tabclose'), { desc = 'Close tab' })
-- Movement related
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })

-- usage of plugins
-- plugin manager: Lazy.nvim
map('n', '<Leader>pu', cmd('Lazy update'), { desc = 'Update plugins' })
map('n', '<Leader>pi', cmd('Lazy install'), { desc = 'Install plugins' })

-- LSP keys are Neovim's own (grr, gri, grt, grn, gra, gO, K, <C-]>);
-- lua/core/lsp.lua adds only the inlay-hint toggle on top.
-- <Leader>fw (format buffer) is owned by plugins/conform.lua

-- Deletes all marks
map('n', '<Leader>dm', cmd('delm! | delm A-Z0-9'), { desc = 'Delete all marks' })

-- Treesitter incremental selection (see core/incremental_selection.lua)
map('n', '<C-space>', function()
  require('core.incremental_selection').start()
end, { desc = 'Start incremental selection' })
map('x', '<C-space>', function()
  require('core.incremental_selection').increment()
end, { desc = 'Expand selection to parent node' })
map('x', '<BS>', function()
  require('core.incremental_selection').decrement()
end, { desc = 'Shrink selection' })

-- Diagnostics (built-in vim.diagnostic, no plugin needed)
map('n', '<Leader>dd', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
map('n', '[d', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Previous diagnostic' })
map('n', ']d', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Next diagnostic' })
map('n', '<Leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic list' })
