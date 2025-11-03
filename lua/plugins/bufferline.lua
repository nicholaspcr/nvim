local function bufferline()
  vim.opt.termguicolors = true
  require('bufferline').setup{
    options = {
      mode = 'tabs',
    },
  }
end

return {
  'akinsho/bufferline.nvim',
  event = 'BufAdd',
  dependencies = {'nvim-tree/nvim-web-devicons'},
  version = '*',
  config = bufferline,
}
