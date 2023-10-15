
local package = require('core.pack').package
local conf = require('modules.ui.config')

package({
  'lukas-reineke/indent-blankline.nvim',
  main = "ibl",
  event = 'BufRead',
  config = conf.indent_blankline,
})

package({
  'nvim-lualine/lualine.nvim',
  config = conf.lualine,
  after = "nvim-web-devicons",
  dependencies = {{'nvim-tree/nvim-web-devicons', opt = true }},
})

package({
  "folke/todo-comments.nvim",
  dependencies = {{ "nvim-lua/plenary.nvim" }},
  config = conf.todo,
})

package({
  'lewis6991/gitsigns.nvim',
  config = conf.gitsigns,
})

package({
  'nvim-tree/nvim-web-devicons',
  config = function() require'nvim-web-devicons'.setup() end,
})

package({
  'akinsho/bufferline.nvim', 
  version = "*", 
  after = "nvim-web-devicons",
  requires = "nvim-tree/nvim-web-devicons",
  config = conf.bufferline,
})


-- Packages related to ColorScheme
-- Configs are commented in order to leave just the default settings be set.

package({
  'folke/tokyonight.nvim',
  --config = conf.tokyonight,
})

package({
  'luisiacc/gruvbox-baby',
  --config = conf.gruvboxBaby,
})

package({
  'morhetz/gruvbox',
  config = conf.gruvbox,
})

package({
  'rebelot/kanagawa.nvim',
  --config = conf.kanagawa,
})

