return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require('git-worktree').setup({
      -- Suppress warnings and errors
      change_directory_command = 'cd',
      update_on_change = true,
      update_on_change_command = 'e .',
      clearjumps_on_change = true,
      autopush = false,
    })

    -- Define missing highlight groups to prevent warnings
    vim.api.nvim_set_hl(0, 'TelescopeResultsComment', { link = 'Comment' })
  end,
}
