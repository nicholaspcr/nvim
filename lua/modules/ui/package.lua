
local package = require('core.pack').package
local conf = require('modules.ui.config')

package({
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufRead',
  config = conf.indent_blankline,
})

package({
  'nvim-lualine/lualine.nvim',
  config = conf.lualine,
  dependencies = {{ 'kyazdani42/nvim-web-devicons', opt = true }},
})
