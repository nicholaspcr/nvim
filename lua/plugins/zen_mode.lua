-- Zen mode for focused writing
return {
  'folke/zen-mode.nvim',
  keys = {
    { '<Leader>oz', '<cmd>ZenMode<CR>', desc = 'Zen Mode' },
  },
  opts = {
    window = {
      backdrop = 0.95,
      width = 100,
      height = 1,
      options = {
        signcolumn = 'no',
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = '0',
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = false },
      gitsigns = { enabled = false },
      tmux = { enabled = false },
    },
    on_open = function()
      vim.opt.wrap = true
      vim.opt.linebreak = true
    end,
    on_close = function()
      vim.opt.wrap = false
      vim.opt.linebreak = false
    end,
  },
}
