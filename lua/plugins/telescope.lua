
local telescope_setup = {
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
  defaults = {
    layout_config = {
      horizontal = { prompt_position = 'top', results_width = 0.6 },
      vertical = { mirror = false },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    sorting_strategy = 'ascending',
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

    file_ignore_patterns = {
      'vendor/*',
      '%.lock',
      '__pycache__/*',
      '%.sqlite3',
      '%.ipynb',
      'node_modules/*',
      '%.jpg',
      '%.jpeg',
      '%.png',
      '%.svg',
      '%.otf',
      '%.ttf',
      '%.webp',
      '.dart_tool/',
      '.gradle/',
      '.idea/',
      '.vscode/',
      '__pycache__/',
      'build/',
      'env/',
      'gradle/',
      'node_modules/',
      'target/',
      '%.pdb',
      '%.dll',
      '%.class',
      '%.exe',
      '%.cache',
      '%.ico',
      '%.pdf',
      '%.dylib',
      '%.jar',
      '%.docx',
      '%.met',
      'smalljre_*/*',
      '.vale/',

      -- custom files
      '^data/*',
      'go.sum',
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    file_browser = { theme = 'ivy' },
  },
}


local function telescope()
  require('telescope').load_extension 'file_browser'
  require('telescope').load_extension 'fzy_native'
  require('telescope').load_extension 'git_worktree'
  require('telescope').setup(telescope_setup)

  local git_worktree = require('telescope').extensions.git_worktree
  local utils = require('telescope.utils')

  local map = require('core.keymap').map
  local cmd = require('core.keymap').cmd_func

  -- Buffer related mappings
  map('n', '<Leader>b', cmd('Telescope buffers'))
  -- File related mappings
  map('n', '<Leader>fa', cmd('Telescope live_grep'))
  map('n', '<Leader>fd', function() require'telescope.builtin'.live_grep{ cwd=utils.buffer_dir() } end)
  map('n', '<Leader>cs', cmd('Telescope colorscheme'))
  map('n', '<Leader>gs', cmd('Telescope git_status'))
  map('n', '<Leader>ff', cmd('Telescope find_files'))
  map('n', '<Leader>fl', cmd('Telescope file_browser path=%:p:h select_buffer=true'))

  -- Todo related mappings
  map('n', '<Leader>ft', cmd('TodoTelescope'))

  -- Worktree related mappings
  map('n', '<Leader>wl', git_worktree.git_worktrees)
  map('n', '<Leader>wc', git_worktree.create_git_worktree)

  -- Obsidian related mappings
  map('n', '<Leader>on', cmd('ObsidianNew'))
  map('n', '<Leader>ow', cmd('ObsidianWorkspace'))
  map('n', '<Leader>ot', cmd('ObsidianToday'))
  map('n', '<Leader>fot', cmd('ObsidianTags'))
  map('n', '<Leader>fof', cmd('ObsidianQuickSwitch'))
end


return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'ThePrimeagen/git-worktree.nvim',
    'folke/todo-comments.nvim',
    'epwalsh/obsidian.nvim',
  },
  config = telescope,
}
