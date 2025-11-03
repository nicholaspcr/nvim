local function noice()
  require('notify').setup({
    background_colour = '#000000',
    render = 'compact',
    timeout = 3000,  -- 3 seconds
  })
  require('noice').setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
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
          event = "msg_show",
          find = "Invalid.*hl_group",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify",
          find = "Invalid.*hl_group",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "Finder failed with msg",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "lua_error",
          find = "Invalid.*hl_group",
        },
        opts = { skip = true },
      },
    },
  })
end

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  version = 'v4.10.0',
  dependencies = {
	  'MunifTanjim/nui.nvim',
	  'rcarriga/nvim-notify',
      'hrsh7th/nvim-cmp',
  },
  config = noice,
}
