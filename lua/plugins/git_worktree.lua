-- Stack a new worktree branch off the current branch.
-- Supports bare repo layout (trees/<branch>) and regular repos (sibling dir).
local function stack_worktree()
  local branch = vim.fn.input('New stacked branch name: ')
  if branch == '' then
    return
  end

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
end

local function telescope_worktree()
  local ok, git_worktree = pcall(function()
    return require('telescope').extensions.git_worktree
  end)
  if ok then
    return git_worktree
  end
  vim.notify('git-worktree telescope extension unavailable', vim.log.levels.ERROR)
end

-- Worktree name: path relative to <git-common-dir>/trees/ (bare repo layout),
-- otherwise the directory basename.
local function worktree_name(path, trees_prefix)
  local resolved = vim.fn.resolve(path)
  if trees_prefix and vim.startswith(resolved, trees_prefix) then
    return resolved:sub(#trees_prefix + 1)
  end
  return vim.fn.fnamemodify(path, ':t')
end

-- Parse `git worktree list --porcelain` into entries, skipping the bare repo.
local function list_worktrees()
  local lines = vim.fn.systemlist({ 'git', 'worktree', 'list', '--porcelain' })
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local common_dir = vim.fn.systemlist({ 'git', 'rev-parse', '--path-format=absolute', '--git-common-dir' })[1]
  local trees_prefix = vim.v.shell_error == 0 and common_dir and (vim.fn.resolve(common_dir) .. '/trees/') or nil

  local entries = {}
  local current = nil
  for _, line in ipairs(vim.list_extend(lines, { '' })) do
    local path = line:match('^worktree (.+)$')
    if path then
      current = { path = path, name = worktree_name(path, trees_prefix) }
    elseif current and line == 'bare' then
      current = vim.tbl_extend('force', current, { bare = true })
    elseif current and line:match('^HEAD ') then
      current = vim.tbl_extend('force', current, { sha = line:sub(6, 12) })
    elseif line == '' and current then
      if not current.bare then
        table.insert(entries, current)
      end
      current = nil
    end
  end
  return entries
end

-- Finder for the extension's picker that shows the worktree name instead of
-- the branch. The extension's mappings only rely on `entry.path`.
local function worktree_name_finder()
  local finders = require('telescope.finders')
  local entry_display = require('telescope.pickers.entry_display')
  local results = list_worktrees()

  local width = function(key)
    local max = 0
    for _, entry in ipairs(results) do
      max = math.max(max, vim.fn.strdisplaywidth(entry[key] or ''))
    end
    return max
  end

  local displayer = entry_display.create({
    separator = ' ',
    items = { { width = width('name') }, { width = width('path') }, { remaining = true } },
  })

  return finders.new_table({
    results = results,
    entry_maker = function(entry)
      return vim.tbl_extend('force', entry, {
        value = entry.name,
        ordinal = entry.name,
        display = function(e)
          return displayer({ { e.name, 'TelescopeResultsIdentifier' }, { e.path }, { e.sha or '' } })
        end,
      })
    end,
  })
end

return {
  'polarmutex/git-worktree.nvim',
  version = '^2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<Leader>wl',
      function()
        local ext = telescope_worktree()
        if ext then
          ext.git_worktree({ finder = worktree_name_finder() })
        end
      end,
      desc = 'List worktrees (M-d to delete)',
    },
    {
      '<Leader>wc',
      function()
        local ext = telescope_worktree()
        if ext then
          ext.create_git_worktree({ prefix = 'trees/' })
        end
      end,
      desc = 'Create worktree',
    },
    { '<Leader>ws', stack_worktree, desc = 'Stack new worktree branch' },
  },
  config = function()
    vim.g.git_worktree = {
      change_directory_command = 'cd',
      update_on_change = true,
      update_on_change_command = 'e .',
      clearjumps_on_change = true,
      autopush = false,
    }
    pcall(require('telescope').load_extension, 'git_worktree')
  end,
}
