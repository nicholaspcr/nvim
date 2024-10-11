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
    { 'kdheepak/lazygit.nvim' },
  },
  config = conf.telescope,
})

package({
  'ThePrimeagen/git-worktree.nvim',
  config = function()
    require("git-worktree").setup()
  end,
})

package({
  "epwalsh/obsidian.nvim",
  version = "v3.7.12",  -- recommended, use latest release instead of latest commit
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
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
  },
})
