local package = require('core.pack').package
local conf = require('modules.navigation.config')

package({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim' }
    -- { 'kdheepak/lazygit.nvim' }
  },
  config = conf.telescope,
  init = function()
    -- To get telescope-file-browser loaded and working with telescope,
    -- you need to call load_extension, somewhere after setup function:
    require("telescope").load_extension "file_browser"
    --require("telescope").load_extension "lazygit"


    vim.g.mapleader = ' '
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent


    -- Telescope mappings
    nmap({
      { '<Leader>b', cmd('Telescope buffers'), opts(noremap, silent) },
      { '<Leader>fa', cmd('Telescope live_grep'), opts(noremap, silent) },
      { '<Leader>ff', cmd('Telescope find_files'), opts(noremap, silent) },
      { '<Leader>fw', cmd('Telescope file_browser'), opts(noremap, silent) },
      { '<Leader>fl', cmd('Telescope file_browser path=%:p:h select_buffer=true'), opts(noremap, silent) },
    })
  end
})



package({
  'ThePrimeagen/harpoon',
  dependencies = { {'nvim-lua/plenary.nvim'},},
  init = function()
    vim.g.mapleader = ' '
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent
    nmap({
      { '<C-e>', function() require('harpoon.ui').toggle_quick_menu() end, opts(noremap, silent) },
      { '<Leader>a', function() require("harpoon.mark").add_file() end, opts(noremap, silent) },
      { '<C-h>', function() require('harpoon.ui').nav_file(1) end, opts(noremap, silent) },
      { '<C-j>', function() require('harpoon.ui').nav_file(2) end, opts(noremap, silent) },
      { '<C-k>', function() require('harpoon.ui').nav_file(3) end, opts(noremap, silent) },
      { '<C-l>', function() require('harpoon.ui').nav_file(4) end, opts(noremap, silent) },
    })
  end
})

package ({
  'kdheepak/lazygit.nvim',
  init = function()
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent
    nmap({ '<Leader>gt', cmd('LazyGit'), opts(noremap, silent) })
  end
})
