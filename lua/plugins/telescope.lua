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
      '--smart-case',
    },
    sorting_strategy = 'ascending',
    file_previewer = function(...)
      return require('telescope.previewers').vim_buffer_cat.new(...)
    end,
    grep_previewer = function(...)
      return require('telescope.previewers').vim_buffer_vimgrep.new(...)
    end,
    qflist_previewer = function(...)
      return require('telescope.previewers').vim_buffer_qflist.new(...)
    end,

    -- These are Lua patterns, not globs. A trailing '/*' reads as "slash,
    -- repeated zero or more times", so it matches the bare prefix too --
    -- '^data/*' was hiding database.go and data.json. Directories therefore
    -- end in a plain '/', and extensions are anchored with '$'.
    file_ignore_patterns = {
      -- Directories
      'vendor/',
      '__pycache__/',
      'node_modules/',
      'target/',
      'build/',
      'gradle/',
      '%.dart_tool/',
      '%.idea/',
      '%.vscode/',
      '%.vale/',
      '^env/',
      '^data/',
      'smalljre_[^/]*/',

      -- Generated Go: protoc writes foo.pb.go, its plugins add foo.pb.gw.go,
      -- foo.pb.fm.go, foo.pb.validate.go and friends.
      '%.pb%.go$',
      '%.pb%.[%w%.]+%.go$',

      -- Lockfiles
      '%.lock$',
      'go%.sum$',

      -- Binaries and archives
      '%.class$',
      '%.dll$',
      '%.dylib$',
      '%.exe$',
      '%.jar$',
      '%.pdb$',

      -- Images and fonts
      '%.ico$',
      '%.jpe?g$',
      '%.otf$',
      '%.png$',
      '%.svg$',
      '%.ttf$',
      '%.webp$',

      -- Documents and data blobs
      '%.cache$',
      '%.docx$',
      '%.ipynb$',
      '%.met$',
      '%.pdf$',
      '%.sqlite3$',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    file_browser = {
      theme = 'ivy',
      grouped = true,
      hidden = true,
      respect_gitignore = false,
    },
  },
}

local function telescope()
  local telescope = require('telescope')

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
  -- Dotfile repos keep everything real under .config/, which find_files hides
  -- by default; this variant also ignores .gitignore.
  map('n', '<Leader>fh', function()
    require('telescope.builtin').find_files({
      hidden = true,
      no_ignore = true,
      prompt_title = 'Find Files (hidden, no ignore)',
    })
  end, { desc = 'Find files (hidden)' })
  map('n', '<Leader>fo', cmd('Telescope oldfiles'), { desc = 'Recent files' })
  map('n', '<Leader>fl', cmd('Telescope file_browser path=%:p:h select_buffer=true'), { desc = 'File browser' })

  -- Symbols. Neovim's builtin gO covers document symbols via the quickfix
  -- list; these give a telescope picker and add workspace symbols.
  map('n', '<Leader>fs', cmd('Telescope lsp_document_symbols'), { desc = 'Document symbols' })
  map('n', '<Leader>fS', cmd('Telescope lsp_dynamic_workspace_symbols'), { desc = 'Workspace symbols' })

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
    { '<Leader>fh', desc = 'Telescope find files (hidden)' },
    { '<Leader>fo', desc = 'Telescope recent files' },
    { '<Leader>fl', desc = 'Telescope file browser' },
    { '<Leader>fs', desc = 'Telescope document symbols' },
    { '<Leader>fS', desc = 'Telescope workspace symbols' },
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
