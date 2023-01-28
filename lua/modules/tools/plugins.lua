-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.tools.config')

plugin({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  config = conf.telescope,
  requires = {
    { 'nvim-lua/plenary.nvim', opt = true },
    { 'nvim-telescope/telescope-fzy-native.nvim', opt = true },
    { 'nvim-telescope/telescope-file-browser.nvim', opt = true },
  },
})

plugin({
  'editorconfig/editorconfig-vim',
  ft = {'typescript', 'javascript', 'vim', 'rust', 'zig', 'c', 'cpp' },
})

plugin({ '~/Workspace/mcc.nvim', ft = { 'c', 'cpp', 'go', 'rust' }, config = conf.mcc_nvim })

plugin({ 'phaazon/hop.nvim', event = 'BufRead', config = conf.hop })

plugin({ 'fatih/vim-go' })
