local function bufferline()
  local ok, bufferline = pcall(require, 'bufferline')
  if not ok then
    vim.notify("Failed to load bufferline", vim.log.levels.ERROR)
    return
  end

  bufferline.setup{
    options = {
      mode = 'tabs',
      separator_style = 'thin',
      show_tab_indicators = true,
      indicator = {
        style = 'underline',
      },
      modified_icon = '●',
      show_close_icon = false,
      show_buffer_close_icons = false,
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
