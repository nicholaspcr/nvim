local plugin = require('core.pack').register_plugin

plugin({
  'ThePrimeagen/harpoon',
  config = function()
    if not packer_plugins['plenary.nvim'].loaded then
      vim.cmd([[packadd plenary.nvim]])
    end
  end,
})
