-- Telescope fuzzy finder configuration
-- Version: Using latest stable release

-- Custom buffer previewer that handles missing treesitter parsers
local function buffer_previewer_maker(filepath, bufnr, opts)
  opts = opts or {}

  local previewers = require('telescope.previewers')
  local Job = require('plenary.job')

  -- Use cat for preview without treesitter highlighting
  -- This prevents errors when treesitter parsers are missing
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = 'cat',
    args = { filepath },
    on_exit = vim.schedule_wrap(function(j, exit_code)
      if exit_code ~= 0 then
        return
      end

      local results = j:result()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, results)

      -- Set filetype for basic syntax highlighting (non-treesitter)
      local ft = vim.filetype.match({ buf = bufnr, filename = filepath })
      if ft then
        vim.api.nvim_buf_set_option(bufnr, 'filetype', ft)
      end
    end),
  }):start()
end

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

    -- Use custom previewer to avoid treesitter parser errors
    buffer_previewer_maker = buffer_previewer_maker,

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

  -- Override notify to suppress telescope highlight warnings
  local original_notify = vim.notify
  vim.notify = function(msg, level, opts)
    -- Filter out telescope highlight group warnings
    if type(msg) == "string" and msg:match("Invalid.*hl_group") then
      return
    end
    original_notify(msg, level, opts)
  end

  telescope.setup(telescope_setup)

  -- Load extensions with error handling
  pcall(telescope.load_extension, 'file_browser')
  pcall(telescope.load_extension, 'fzf')

  -- Suppress warnings when loading git_worktree extension
  local notify_level = vim.log.levels.WARN
  vim.log.levels.WARN = vim.log.levels.ERROR
  pcall(telescope.load_extension, 'git_worktree')
  vim.log.levels.WARN = notify_level

  local map = require('core.keymap').map
  local cmd = require('core.keymap').cmd_func

  -- Buffer related mappings
  map('n', '<Leader>b', cmd('Telescope buffers'))
  -- File related mappings
  map('n', '<Leader>fa', cmd('Telescope live_grep'))
  map('n', '<Leader>fd', function()
    local utils = require('telescope.utils')
    require('telescope.builtin').live_grep({ cwd = utils.buffer_dir() })
  end)
  map('n', '<Leader>cs', cmd('Telescope colorscheme'))
  map('n', '<Leader>gs', cmd('Telescope git_status'))
  map('n', '<Leader>ff', cmd('Telescope find_files'))
  map('n', '<Leader>fl', cmd('Telescope file_browser path=%:p:h select_buffer=true'))
  -- Note: 'gr' and 'gi' are buffer-local LSP keymaps set in mason.lua on_attach


  -- Todo related mappings
  map('n', '<Leader>ft', cmd('TodoTelescope'))

  -- Worktree related mappings
  map('n', '<Leader>wl', function()
    local ok, git_worktree = pcall(function()
      return require('telescope').extensions.git_worktree
    end)
    if ok then
      git_worktree.git_worktrees()
    end
  end)
  map('n', '<Leader>wc', function()
    local ok, git_worktree = pcall(function()
      return require('telescope').extensions.git_worktree
    end)
    if ok then
      git_worktree.create_git_worktree()
    end
  end)

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
  keys = {
    { '<Leader>b', desc = 'Telescope buffers' },
    { '<Leader>fa', desc = 'Telescope live grep' },
    { '<Leader>fd', desc = 'Telescope grep in directory' },
    { '<Leader>cs', desc = 'Telescope colorscheme' },
    { '<Leader>gs', desc = 'Telescope git status' },
    { '<Leader>ff', desc = 'Telescope find files' },
    { '<Leader>fl', desc = 'Telescope file browser' },
    { '<Leader>ft', desc = 'Todo telescope' },
    { '<Leader>wl', desc = 'List worktrees' },
    { '<Leader>wc', desc = 'Create worktree' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-file-browser.nvim',
    'ThePrimeagen/git-worktree.nvim',
    'folke/todo-comments.nvim',
    'epwalsh/obsidian.nvim',
  },
  config = telescope,
}
