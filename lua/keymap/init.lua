-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT
-- recommend plugins key defines in this file
--
local api = vim.api
require('keymap.remap')
local keymap = require('core.keymap')
local nmap, xmap, tmap = keymap.nmap, keymap.xmap, keymap.tmap
local opts = keymap.new_opts
local silent, noremap = keymap.silent, keymap.noremap
local cmd = keymap.cmd
require('keymap.config')

nmap({
  -- packer
  { '<Leader>pu', cmd('PackerUpdate') },
  { '<Leader>pi', cmd('PackerInstall') },
  { '<Leader>pc', cmd('PackerCompile') },
  -- Lsp
  { '<Leader>li', cmd('LspInfo') },
  { '<Leader>ll', cmd('LspLog') },
  { '<Leader>lr', cmd('LspRestart') },
  -- Lspsaga
  { '[e', cmd('Lspsaga diagnostic_jump_next') },
  { ']e', cmd('Lspsaga diagnostic_jump_prev') },
  { '[c', cmd('Lspsaga show_cursor_diagnostics') },
  { 'K', cmd('Lspsaga hover_doc') },
  { 'ga', cmd('Lspsaga code_action') },
  { 'gd', cmd('Lspsaga peek_definition') },
  { 'gs', cmd('Lspsaga signature_help') },
  { 'gr', cmd('Lspsaga rename') },
  { 'gh', cmd('Lspsaga lsp_finder') },
  { '<Leader>o', cmd('LSoutlineToggle') },
  { '<Leader>g', cmd('Lspsaga open_floaterm lazygit') },
  -- dashboard create file
  { '<Leader>n', cmd('DashboardNewFile') },
  { '<Leader>ss', cmd('SessionSave') },
  { '<Leader>sl', cmd('SessionLoad') },
  -- dadbodui
  { '<Leader>d', cmd('DBUIToggle') },
  -- Telescope
  { '<Leader>j', cmd('Telescope buffers') },
  { '<Leader>fa', cmd('Telescope live_grep') },
  {
    '<Leader>e',
    function()
      vim.cmd('Telescope file_browser')
      local esc_key = api.nvim_replace_termcodes('<Esc>', true, false, true)
      api.nvim_feedkeys(esc_key, 'n', false)
    end,
  },
  { '<Leader>ff', cmd('Telescope find_files find_command=rg,--ignore,--hidden,--files') },
  { '<Leader>fg', cmd('Telescope git_files') },
  { '<Leader>fw', cmd('Telescope grep_string') },
  { '<Leader>fh', cmd('Telescope help_tags') },
  { '<Leader>fo', cmd('Telescope oldfiles') },
  { '<Leader>gc', cmd('Telescope git_commits') },
  { '<Leader>fd', cmd('Telescope dotfiles') },
  -- hop.nvim
  { 'f', cmd('HopWordAC') },
  { 'F', cmd('HopWordBC') },
})

nmap({ 'gcc', cmd('ComComment') })
xmap({ 'gcc', ':ComComment<CR>' })
nmap({ 'gcj', cmd('ComAnnotation') })

-- Lspsaga floaterminal
nmap({ '<A-d>', cmd('Lspsaga open_floaterm') })
tmap({ '<A-d>', [[<C-\><C-n>:Lspsaga close_floaterm<CR>]] })

xmap({ 'ga', cmd('Lspsaga code_action') })


-- Harpoon keybindings
nmap({
  { '<leader>hc', function() require("harpoon.cmd-ui").toggle_quick_menu() end, opts(silent, noremap) },
  { '<C-e>', function() require('harpoon.ui').toggle_quick_menu() end, opts(silent, noremap) },
  { '<leader>a', function() require("harpoon.mark").add_file() end, opts(silent, noremap) },
  { '<C-h>', function() require('harpoon.ui').nav_file(1) end, opts(silent, noremap) },
  { '<C-j>', function() require('harpoon.ui').nav_file(2) end, opts(silent, noremap) },
  { '<C-k>', function() require('harpoon.ui').nav_file(3) end, opts(silent, noremap) },
  { '<C-l>', function() require('harpoon.ui').nav_file(4) end, opts(silent, noremap) },
})
