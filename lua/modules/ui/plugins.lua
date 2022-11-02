-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.ui.config')

plugin({ 'glepnir/zephyr-nvim', config = conf.zephyr })

plugin({ 'glepnir/dashboard-nvim', config = conf.dashboard })

plugin({
  'glepnir/galaxyline.nvim',
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons',
})

local enable_indent_filetype = {
  'go',
  'lua',
  'sh',
  'rust',
  'cpp',
  'typescript',
  'typescriptreact',
  'javascript',
  'json',
  'python',
}

plugin({
  'lukas-reineke/indent-blankline.nvim',
  ft = enable_indent_filetype,
  config = conf.indent_blankline,
})

plugin({
  'lewis6991/gitsigns.nvim',
  event = { 'BufRead', 'BufNewFile' },
  config = conf.gitsigns,
})

plugin({
  'kyazdani42/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  config = conf.nvim_tree,
  requires = 'kyazdani42/nvim-web-devicons',
})

-- plugin({ 'akinsho/nvim-bufferline.lua', config = conf.nvim_bufferline, requires = 'kyazdani42/nvim-web-devicons' })
