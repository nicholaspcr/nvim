local keymap = require('core.keymap')
local map = keymap.map
local cmd = keymap.cmd

-- close buffer
map('n', '<C-x>k', cmd('bdelete'))
map('n', '<C-x>p', cmd('let @+=expand("%:p")'))

-- save
map('n', '<C-s>', cmd('write'))
-- yank
map('n', 'Y', 'y$')
-- buffer jump
map('n', ']b', cmd('bn'))
map('n', '[b', cmd('bp'))
-- remove trailing white space
map('n', '<Leader>tw', cmd('TrimTrailingWhitespace'))
map('n', '<Leader><CR>', ':noh<CR>')
-- Tab related
map('n', '<Leader>tn', cmd('tabnew'))
map('n', '<Leader>tc', cmd('tabclose'))
-- Movement related
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- usage of plugins
-- plugin manager: Lazy.nvim
map('n', '<Leader>pu', cmd('Lazy update'))
map('n', '<Leader>pi', cmd('Lazy install'))

-- LSP keymaps are now buffer-local (see mason.lua on_attach)
-- Global formatting keymap
map('n', '<Leader>fw', vim.lsp.buf.format)

-- Deletes all marks
map('n', '<Leader>dm', cmd('delm! | delm A-Z0-9'))
