return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local alpha = require'alpha'
    local dashboard = require'alpha.themes.dashboard'

    dashboard.section.header.val = {
      [[                                           ]],
      [[                                           ]],
      [[        _   _   _    ___   _    __         ]],
      [[       | \ | | | | / _ _\ | |  / /         ]],
      [[       |  \| | | | | | |_|| |_/ /          ]],
      [[       |     | | | | |  _ |    /           ]],
      [[       | |\  | | | | |_| || |\  \          ]],
      [[       |_| \_| |_|  \___/ |_| \__\         ]],
      [[                                           ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
      dashboard.button("e", "  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("h", "  Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("u", "  Lazy update", ":Lazy update <CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    local function footer()
      -- local fortune = require('alpha.fortune')()
      -- return fortune
      return "quote of the day"
    end

    dashboard.section.footer.val = footer()

    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 2 },
      dashboard.section.footer
    }
    alpha.setup(dashboard.opts)
  end
}
