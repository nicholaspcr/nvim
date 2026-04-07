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
  pcall(telescope.load_extension, 'file_browser')
  pcall(telescope.load_extension, 'fzf')

  pcall(telescope.load_extension, 'git_worktree')

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

  -- Worktree related mappings
  map('n', '<Leader>wl', function()
    local ok, git_worktree = pcall(function()
      return require('telescope').extensions.git_worktree
    end)
    if ok then
      git_worktree.git_worktree()
    end
  end)
  map('n', '<Leader>wc', function()
    local ok, git_worktree = pcall(function()
      return require('telescope').extensions.git_worktree
    end)
    if ok then
      git_worktree.create_git_worktree({ prefix = 'trees/' })
    end
  end)

  -- Stack a new worktree branch off the current branch.
  -- Supports bare repo layout (trees/<branch>) and regular repos (sibling dir).
  map('n', '<Leader>ws', function()
    local branch = vim.fn.input('New stacked branch name: ')
    if branch == '' then return end

    local git_common_dir = vim.fn.systemlist('git rev-parse --git-common-dir')[1]
    if vim.v.shell_error ~= 0 then
      vim.notify('Not in a git repository', vim.log.levels.ERROR)
      return
    end
    git_common_dir = vim.fn.resolve(git_common_dir)

    local dir
    local trees_dir = git_common_dir .. '/trees'
    if vim.fn.isdirectory(trees_dir) == 1 then
      -- Bare repo layout: worktrees live in trees/<branch_path>
      dir = trees_dir .. '/' .. branch
    else
      -- Regular repo: worktree as sibling directory
      local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
      local basename = vim.fn.fnamemodify(root, ':t')
      local parent_dir = vim.fn.fnamemodify(root, ':h')
      dir = parent_dir .. '/' .. basename .. '-' .. branch:gsub('/', '-')
    end

    local current = vim.fn.systemlist('git branch --show-current')[1] or 'HEAD'
    local result = vim.fn.system({ 'git', 'worktree', 'add', dir, '-b', branch })
    if vim.v.shell_error ~= 0 then
      vim.notify('Failed to create worktree: ' .. vim.trim(result), vim.log.levels.ERROR)
      return
    end
    vim.cmd('lcd ' .. vim.fn.fnameescape(dir))
    vim.cmd('e .')
    vim.notify('Stacked worktree: ' .. branch .. ' (from ' .. current .. ')')
  end)

  -- Obsidian related mappings (unified under <Leader>o)
  map('n', '<Leader>on', cmd('ObsidianNew'), { desc = 'New note' })
  map('n', '<Leader>ow', cmd('ObsidianWorkspace'), { desc = 'Workspace' })
  map('n', '<Leader>ot', cmd('ObsidianToday'), { desc = 'Today' })
  map('n', '<Leader>oy', cmd('ObsidianYesterday'), { desc = 'Yesterday' })
  map('n', '<Leader>os', cmd('ObsidianTags'), { desc = 'Search tags' })
  map('n', '<Leader>of', cmd('ObsidianQuickSwitch'), { desc = 'Find notes' })
  map('n', '<Leader>ob', cmd('ObsidianBacklinks'), { desc = 'Backlinks' })
  map('n', '<Leader>ol', cmd('ObsidianLinks'), { desc = 'Outgoing links' })
  map('n', '<Leader>oR', cmd('ObsidianRename'), { desc = 'Rename note' })
  map('n', '<Leader>oT', cmd('ObsidianTemplate'), { desc = 'Insert template' })

  -- Grep notes content
  map('n', '<Leader>og', function()
    require('telescope.builtin').live_grep({
      cwd = vim.fn.expand('~/notes'),
      prompt_title = 'Search Notes Content',
    })
  end)

  -- Browse daily notes
  map('n', '<Leader>od', function()
    require('telescope.builtin').find_files({
      cwd = vim.fn.expand('~/notes/daily'),
      prompt_title = 'Daily Notes',
      sorting_strategy = 'descending',
    })
  end)

  -- Recent notes (modified in last 7 days)
  map('n', '<Leader>or', function()
    require('telescope.builtin').find_files({
      cwd = vim.fn.expand('~/notes/notes'),
      prompt_title = 'Recent Notes (7d)',
      find_command = { 'fd', '--type', 'f', '-e', 'md', '--changed-within', '7d' },
    })
  end)
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
    { '<Leader>wl', desc = 'List worktrees' },
    { '<Leader>wc', desc = 'Create worktree' },
    { '<Leader>ws', desc = 'Stack new worktree branch' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-file-browser.nvim',
    'polarmutex/git-worktree.nvim',
    'folke/todo-comments.nvim',
    'epwalsh/obsidian.nvim',
  },
  config = telescope,
}
