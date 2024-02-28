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
    { 'epwalsh/obsidian.nvim' },
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
      { '<Leader>wl', extensions.git_worktree.git_worktrees, opts(noremap, silent) },
      { '<Leader>wc', extensions.git_worktree.create_git_worktree, opts(noremap, silent) },

      -- Obsidian related mappings
      { '<Leader>on', cmd('ObsidianNew'), opts(noremap, silent) },
      { '<Leader>ow', cmd('ObsidianWorkspace'), opts(noremap, silent) },
      { '<Leader>ot', cmd('ObsidianToday'), opts(noremap, silent) },
      { '<Leader>fot', cmd('ObsidianTags'), opts(noremap, silent) },
      { '<Leader>fof', cmd('ObsidianQuickSwitch'), opts(noremap, silent) },
    })
  end
})



package({
  'ThePrimeagen/harpoon',
  branch = "harpoon2",
  dependencies = { 
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
    require("harpoon").setup({
      settings = {
        save_on_toggle = true
      }
    })
  end,
  init = function()
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent

    local harpoon = require("harpoon")
    vim.g.mapleader = ' '

    local telescope_conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
              results = file_paths,
          }),
          previewer = telescope_conf.file_previewer({}),
          sorter = telescope_conf.generic_sorter({}),
      }):find()
    end


    nmap({
      { '<Leader>a', function() harpoon:list():append() end, opts(noremap, silent) },
      { '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, opts(noremap, silent) },
      { '<Leader>fe', function() toggle_telescope(harpoon:list()) end, opts(noremap, silent) },
       

      -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
      -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
      -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
      -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
    })
  end
})

package({
  'ThePrimeagen/git-worktree.nvim',
  config = function()
    require("git-worktree").setup()
  end,
})

package({
  "epwalsh/obsidian.nvim",
  version = "v3.6.0",  -- recommended, use latest release instead of latest commit
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-path",
  },
  config = conf.obsidian,
})


package ({
  'kdheepak/lazygit.nvim',
  init = function()
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent
    nmap({ '<Leader>lg', cmd('LazyGit'), opts(noremap, silent) })
  end
})
