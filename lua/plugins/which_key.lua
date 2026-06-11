return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local wk = require('which-key')
    wk.setup({
      plugins = {
        spelling = { enabled = true },
      },
    })

    -- Register leader key groups.
    -- Individual key descriptions come from each mapping's `desc`, so only
    -- group labels need to be declared here.
    wk.add({
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "DAP/Diagnostics" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Hunk (Git)" },
      { "<leader>i", group = "LSP" },
      { "<leader>o", group = "Obsidian" },
      { "<leader>p", group = "Plugin Manager" },
      { "<leader>r", group = "Rename" },
      { "<leader>s", group = "Spell" },
      { "<leader>t", group = "Toggle/Tab/Test" },
      { "<leader>w", group = "Worktree" },
      { "g", group = "Go to" },
      { "[", group = "Previous" },
      { "]", group = "Next" },
    })
  end,
}
