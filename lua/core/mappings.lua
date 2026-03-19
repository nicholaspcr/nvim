local keymap = require('core.keymap')
local map = keymap.map
local cmd = keymap.cmd

-- close buffer
map('n', '<C-x>k', cmd('bdelete'), { desc = 'Close buffer' })
map('n', '<C-x>p', cmd('let @+=expand("%:p")'), { desc = 'Copy file path' })

-- save
map('n', '<C-s>', cmd('write'), { desc = 'Save file' })
-- yank
map('n', 'Y', 'y$', { desc = 'Yank to end of line' })
-- buffer jump
map('n', ']b', cmd('bn'), { desc = 'Next buffer' })
map('n', '[b', cmd('bp'), { desc = 'Previous buffer' })
-- remove trailing white space
map('n', '<Leader>tw', cmd('TrimTrailingWhitespace'), { desc = 'Trim whitespace' })
map('n', '<Leader><CR>', ':noh<CR>', { desc = 'Clear search highlight' })
-- Tab related
map('n', '<Leader>tn', cmd('tabnew'), { desc = 'New tab' })
map('n', '<Leader>tc', cmd('tabclose'), { desc = 'Close tab' })
-- Movement related
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })

-- usage of plugins
-- plugin manager: Lazy.nvim
map('n', '<Leader>pu', cmd('Lazy update'), { desc = 'Update plugins' })
map('n', '<Leader>pi', cmd('Lazy install'), { desc = 'Install plugins' })

-- LSP keymaps are now buffer-local (see mason.lua on_attach)
-- Global formatting keymap
map('n', '<Leader>fw', vim.lsp.buf.format, { desc = 'Format buffer' })

-- Deletes all marks
map('n', '<Leader>dm', cmd('delm! | delm A-Z0-9'), { desc = 'Delete all marks' })

-- Diagnostics (built-in vim.diagnostic, no plugin needed)
map('n', '<Leader>dd', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<Leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic list' })
