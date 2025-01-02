local keymap = require('core.keymap')
local map = keymap.map
local cmd = keymap.cmd
local telescope = require('telescope.builtin')

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

map('n', 'gd', cmd('Telescope lsp_definitions'))
map('n', 'gr', function () telescope.lsp_references({ show_line = true, include_declaration = true }) end)
map('n', '<Leader>gr', vim.lsp.buf.references)
map('n', 'K', vim.lsp.buf.hover)
map('n', 'gi', function () telescope.lsp_implementations() end)
map('n', '<Leader>D', function () telescope.lsp_type_definitions() end)
map('n', '<Leader>rn', vim.lsp.buf.rename)
map('n', '<Leader>ca', vim.lsp.buf.code_action)

-- Deletes all marks
map('n', '<Leader>dm', cmd('delm! | delm A-Z0-9'))
