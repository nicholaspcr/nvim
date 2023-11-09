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
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case'
      },
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

      file_ignore_patterns = {
        "vendor/*",
        "%.lock",
        "__pycache__/*",
        "%.sqlite3",
        "%.ipynb",
        "node_modules/*",
        "%.jpg",
        "%.jpeg",
        "%.png",
        "%.svg",
        "%.otf",
        "%.ttf",
        "%.webp",
        ".dart_tool/",
        ".gradle/",
        ".idea/",
        ".vscode/",
        "__pycache__/",
        "build/",
        "env/",
        "gradle/",
        "node_modules/",
        "target/",
        "%.pdb",
        "%.dll",
        "%.class",
        "%.exe",
        "%.cache",
        "%.ico",
        "%.pdf",
        "%.dylib",
        "%.jar",
        "%.docx",
        "%.met",
        "smalljre_*/*",
        ".vale/",

        -- custom files
        "^data/*",
        "go.sum",
      }
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
