local package = require('core.pack').package
local conf = require('modules.navigation.config')

package({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'ThePrimeagen/git-worktree.nvim' },
    { 'folke/todo-comments.nvim' },
  },
  config = conf.telescope,
  init = function()
    require("telescope").load_extension "file_browser"
    require("telescope").load_extension "git_worktree"

    vim.g.mapleader = ' '
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent


    local git_worktree = require('telescope').extensions.git_worktree
    local utils = require('telescope.utils')
    -- Telescope mappings
    local extensions = require('telescope').extensions
    nmap({
      -- Buffer related mappings
      { '<Leader>b', cmd('Telescope buffers'), opts(noremap, silent) },

      -- File related mappings
      { '<Leader>fa', cmd('Telescope live_grep'), opts(noremap, silent) },
      { '<Leader>fd', function() require'telescope.builtin'.live_grep{ cwd=utils.buffer_dir() } end, opts(noremap, silent) },
      { '<Leader>cs', cmd('Telescope colorscheme'), opts(noremap, silent) },
      { '<Leader>gs', cmd('Telescope git_status'), opts(noremap, silent) },
      { '<Leader>ff', cmd('Telescope find_files'), opts(noremap, silent) },
      { '<Leader>fl', cmd('Telescope file_browser path=%:p:h select_buffer=true'), opts(noremap, silent) },

      -- Todo related mappings
      { '<Leader>ft', cmd('TodoTelescope'), opts(noremap, silent) },

      -- Worktree related mappings
      { '<Leader>fwl', extensions.git_worktree.git_worktrees, opts(noremap, silent) },
      { '<Leader>fwc', extensions.git_worktree.create_git_worktree, opts(noremap, silent) },
    })
  end
})



package({
  'ThePrimeagen/harpoon',
  dependencies = { {'nvim-lua/plenary.nvim'},},
  init = function()
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent

    vim.g.mapleader = ' '
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

package({
  'ThePrimeagen/git-worktree.nvim',
  config = function()
    require("git-worktree").setup()
  end,
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
