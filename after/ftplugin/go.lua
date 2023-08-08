vim.opt_local.commentstring = '//%s'
vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

local keymap = require('core.keymap')
local nmap = keymap.nmap
local cmd, opts = keymap.cmd, keymap.new_opts
local noremap, silent =  keymap.noremap, keymap.silent
nmap({ '<Leader>ga', cmd(':GoAlternate'), opts(noremap) })
