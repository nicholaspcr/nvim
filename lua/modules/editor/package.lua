local package = require('core.pack').package
local conf = require('modules.editor.config')

package({
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = conf.nvim_treesitter,
  dependencies = {
    {'nvim-treesitter/nvim-treesitter-textobjects'},
  },
})

package({
  'nvim-treesitter/nvim-treesitter-context',
  event = 'BufRead',
  config = conf.nvim_treesitter_context,
  dependencies = {
    {'nvim-treesitter/nvim-treesitter'},
  },
})

package({
  'editorconfig/editorconfig-vim',
  ft = {'typescript', 'javascript', 'vim', 'rust', 'zig', 'c', 'cpp' },
})

-- package({ 'github/copilot.vim' })

package({ 'tpope/vim-fugitive' })
