-- Telescope fuzzy finder configuration
-- Version: Using latest stable release

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
    file_previewer = function(...) return require('telescope.previewers').vim_buffer_cat.new(...) end,
    grep_previewer = function(...) return require('telescope.previewers').vim_buffer_vimgrep.new(...) end,
    qflist_previewer = function(...) return require('telescope.previewers').vim_buffer_qflist.new(...) end,

    file_ignore_patterns = {
      'vendor/*',
      '%.lock',
      '__pycache__/*',
      '%.sqlite3',
      '%.ipynb',
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
      'build/',
      '^env/',
      'gradle/',
      'node_modules/*',
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
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      theme = "ivy",
      grouped = true,
      hidden = true,
      respect_gitignore = false,
    },
  },
}

local function telescope()
  local telescope_ok, telescope = pcall(require, 'telescope')
  if not telescope_ok then
    vim.notify("Failed to load telescope", vim.log.levels.ERROR)
    return
  end

  telescope.setup(telescope_setup)

  -- Load extensions with error handling
  -- (git_worktree is loaded on demand from plugins/git_worktree.lua)
  pcall(telescope.load_extension, 'file_browser')
  pcall(telescope.load_extension, 'fzf')

  local map = require('core.keymap').map
  local cmd = require('core.keymap').cmd

  -- Buffer related mappings
  map('n', '<Leader>b', cmd('Telescope buffers'), { desc = 'Telescope buffers' })
  -- File related mappings
  map('n', '<Leader>fa', cmd('Telescope live_grep'), { desc = 'Live grep' })
  map('n', '<Leader>fd', function()
    local utils = require('telescope.utils')
    require('telescope.builtin').live_grep({ cwd = utils.buffer_dir() })
  end, { desc = 'Grep in directory' })
  map('n', '<Leader>cs', cmd('Telescope colorscheme'), { desc = 'Colorscheme' })
  map('n', '<Leader>gs', cmd('Telescope git_status'), { desc = 'Git status' })
  map('n', '<Leader>ff', cmd('Telescope find_files'), { desc = 'Find files' })
  map('n', '<Leader>fl', cmd('Telescope file_browser path=%:p:h select_buffer=true'), { desc = 'File browser' })
  -- Note: 'gr' and 'gi' are buffer-local LSP keymaps set in mason.lua on_attach


  -- Todo related mappings (shows all tags: TODO, FIX, HACK, WARN, PERF, NOTE, TEST)
  map('n', '<Leader>ft', cmd('TodoTelescope'), { desc = 'Find comment tags (TODO, FIX, NOTE, etc.)' })
  map('n', '<Leader>fT', cmd('TodoTelescope keywords=TODO'), { desc = 'Find TODO' })
  map('n', '<Leader>fF', cmd('TodoTelescope keywords=FIX'), { desc = 'Find FIX/BUG' })
  map('n', '<Leader>fN', cmd('TodoTelescope keywords=NOTE'), { desc = 'Find NOTE' })
  map('n', '<Leader>fW', cmd('TodoTelescope keywords=WARN'), { desc = 'Find WARN' })
  map('n', '<Leader>fH', cmd('TodoTelescope keywords=HACK'), { desc = 'Find HACK' })
  map('n', '<Leader>fP', cmd('TodoTelescope keywords=PERF'), { desc = 'Find PERF' })
  map('n', '<Leader>fE', cmd('TodoTelescope keywords=TEST'), { desc = 'Find TEST' })

  -- Worktree mappings live in plugins/git_worktree.lua
  -- Obsidian/notes mappings live in plugins/obsidian.lua
end


return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {
    { '<Leader>b', desc = 'Telescope buffers' },
    { '<Leader>fa', desc = 'Telescope live grep' },
    { '<Leader>fd', desc = 'Telescope grep in directory' },
    { '<Leader>cs', desc = 'Telescope colorscheme' },
    { '<Leader>gs', desc = 'Telescope git status' },
    { '<Leader>ff', desc = 'Telescope find files' },
    { '<Leader>fl', desc = 'Telescope file browser' },
    { '<Leader>ft', desc = 'Find comment tags (TODO, FIX, NOTE, etc.)' },
    { '<Leader>fT', desc = 'Find TODO' },
    { '<Leader>fF', desc = 'Find FIX/BUG' },
    { '<Leader>fN', desc = 'Find NOTE' },
    { '<Leader>fW', desc = 'Find WARN' },
    { '<Leader>fH', desc = 'Find HACK' },
    { '<Leader>fP', desc = 'Find PERF' },
    { '<Leader>fE', desc = 'Find TEST' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-file-browser.nvim',
    'folke/todo-comments.nvim',
  },
  config = telescope,
}
