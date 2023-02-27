local config = {}

function config.telescope()
  require('telescope').setup({
    pickers = {
      colorscheme = {
        enable_preview = true,
      },
    },
    defaults = {
      layout_config = {
        horizontal = { prompt_position = 'top', results_width = 0.6 },
        vertical = { mirror = false },
      },
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
      file_browser = {
        theme = "ivy",
        hijack_netrw = true,
        --mappings = {
        --  ["i"] = { -- your custom insert mode mappings },
        --  ["n"] = { -- your custom normal mode mappings },
        --},
      },
    },
  })
  require('telescope').load_extension('fzy_native')
end

return config
