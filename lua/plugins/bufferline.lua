-- Tab bar. Runs in 'tabs' mode, so it reflects the builtin gt / gT motions
-- and the <Leader>tn / <Leader>tc pair in lua/core/mappings.lua.
return {
  'akinsho/bufferline.nvim',
  event = 'BufAdd',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  version = '*',
  opts = {
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
  },
}
