local function git_worktree()
  require("git-worktree").setup()
end

return {
  'ThePrimeagen/git-worktree.nvim',
  lazy = false,
  config = git_worktree,
}
