return {
  'RRethy/vim-illuminate',
  event = 'BufRead',
  config = function()
    require('illuminate').configure({
      -- providers: array of providers.. see below
      providers = {
        'lsp',
        'treesitter',
        'regex',
      },
      -- delay: delay in milliseconds
      delay = 100,
      -- filetype_overrides: filetype specific overrides. see below for format
      filetype_overrides = {},
      -- filetypes_denylist: filetypes to not illuminate, this includes 'undotree' and 'neotest-summary' by default
      filetypes_denylist = { 'NvimTree', 'lspsagafinder', 'dashboard' },
      -- modes_denylist: modes to not illuminate, this includes 'gS' (go-to-symbol) by default
      modes_denylist = {},
      -- providers_regex_syntax_denylist: syntax to not illuminate, this includes 'comment' by default
      providers_regex_syntax_denylist = {},
      -- under_cursor: whether or not to illuminate under the cursor
      under_cursor = true,
      -- large_file_cutoff: number of lines at which to use large_file_config
      large_file_cutoff = nil,
      -- large_file_config: config to use for large files (based on large_file_cutoff). see below for format
      large_file_config = nil,
      -- min_count_to_highlight: minimum number of matches required to highlight
      min_count_to_highlight = 1,
    })

    -- Set custom highlight colors for vim-illuminate based on background
    local function set_illuminate_colors()
      if vim.o.background == 'dark' then
        -- Dark theme colors
        vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = '#32302f', underline = true, sp = '#665c54' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = '#32302f', underline = true, sp = '#665c54' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = '#32302f', underline = true, sp = '#665c54' })
        vim.api.nvim_set_hl(0, 'IlluminatedCurWord', { bg = '#3c3836', underline = true, sp = '#fabd2f', bold = true })
      else
        -- Light theme colors
        vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = '#f2e5bc', underline = true, sp = '#928374' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = '#f2e5bc', underline = true, sp = '#928374' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = '#f2e5bc', underline = true, sp = '#928374' })
        vim.api.nvim_set_hl(0, 'IlluminatedCurWord', { bg = '#ebdbb2', underline = true, sp = '#d79921', bold = true })
      end
    end

    set_illuminate_colors()

    -- Update colors when colorscheme changes
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = set_illuminate_colors,
    })
  end,
}
