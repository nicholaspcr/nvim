-- Leader must be set before any <Leader> mappings and before lazy.nvim setup
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, ' ', '<nop>', { silent = true })

-- Disable netrw in favor of telescope-file-browser
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('core.options')
require('core.mappings')
require('core.lazy')
