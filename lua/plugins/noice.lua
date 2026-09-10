local function notify_background()
  -- gruvbox runs with transparent_mode, so Normal has no background for
  -- nvim-notify to inherit and it needs an explicit colour. Track the
  -- light/dark flip that lua/core/theme.lua drives instead of pinning black.
  local palette = require('gruvbox').palette
  return vim.o.background == 'dark' and palette.dark0 or palette.light0
end

local function noice()
  local notify = require('notify')
  notify.setup({
    background_colour = notify_background(),
    render = 'compact',
    timeout = 3000, -- 3 seconds
  })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('notify_background', { clear = true }),
    callback = function()
      notify.setup({ background_colour = notify_background() })
    end,
  })

  require('noice').setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    -- Filter out telescope highlight warnings
    routes = {
      {
        filter = {
          event = 'msg_show',
          find = 'Finder failed with msg',
        },
        opts = { skip = true },
      },
    },
  })
end

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = noice,
}
