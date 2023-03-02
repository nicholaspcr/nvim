local package = require('core.pack').package
local conf = require('modules.editor.config')

package({
  'nvim-treesitter/nvim-treesitter',
  event = 'BufRead',
  run = ':TSUpdate',
  config = conf.nvim_treesitter,
  dependencies = {
    {'nvim-treesitter/nvim-treesitter-textobjects'},
  },
})

package({
  'editorconfig/editorconfig-vim',
  ft = {'typescript', 'javascript', 'vim', 'rust', 'zig', 'c', 'cpp' },
})


package({
  'fatih/vim-go',
  dependencies = {{'https://github.com/junegunn/fzf.vim'}},
})

package({ 'github/copilot.vim' })
