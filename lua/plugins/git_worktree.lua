-- Stack a new worktree branch off the current branch.
-- Supports bare repo layout (trees/<branch>) and regular repos (sibling dir).
local function stack_worktree()
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

return {
  'polarmutex/git-worktree.nvim',
  version = '^2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<Leader>wl',
      function()
        local ext = telescope_worktree()
        if ext then ext.git_worktree() end
      end,
      desc = 'List worktrees (M-d to delete)',
    },
    {
      '<Leader>wc',
      function()
        local ext = telescope_worktree()
        if ext then ext.create_git_worktree({ prefix = 'trees/' }) end
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
