local function bufferline()
  local ok, bufferline = pcall(require, 'bufferline')
  if not ok then
    vim.notify("Failed to load bufferline", vim.log.levels.ERROR)
    return
  end

  vim.opt.termguicolors = true
  bufferline.setup{
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
