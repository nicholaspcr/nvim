
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
  dependencies = {{'nvim-tree/nvim-web-devicons'}},
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
  dependencies = {{'nvim-tree/nvim-web-devicons'}},
  version = "*",
  config = conf.bufferline,
})

package({
  "folke/noice.nvim",
  event = "VeryLazy",
  config = conf.noice,
  dependencies = {
	  {'MunifTanjim/nui.nvim'},
	  {'rcarriga/nvim-notify'},
  },
})

package({
  "catppuccin/nvim",
  name = "catppuccin",
  config = conf.catppuccin,
})
