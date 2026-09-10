-- Highlight other references to the symbol under the cursor.
return {
  'RRethy/vim-illuminate',
  event = 'BufRead',
  config = function()
    require('illuminate').configure({
      providers = { 'lsp', 'regex' },
      delay = 100,
      filetypes_denylist = { 'NvimTree', 'lspsagafinder', 'dashboard', 'alpha' },
      under_cursor = true,
    })

    -- Read the colours out of the gruvbox palette rather than hardcoding them,
    -- so they track the light/dark flip that lua/core/theme.lua drives.
    local function set_colors()
      local palette = require('gruvbox').palette
      local dark = vim.o.background == 'dark'

      local other = {
        bg = dark and palette.dark0_soft or palette.light0_soft,
        sp = dark and palette.dark3 or palette.gray,
        underline = true,
      }
      local current = {
        bg = dark and palette.dark1 or palette.light1,
        sp = dark and palette.bright_yellow or palette.neutral_yellow,
        underline = true,
        bold = true,
      }

      for _, group in ipairs({ 'IlluminatedWordText', 'IlluminatedWordRead', 'IlluminatedWordWrite' }) do
        vim.api.nvim_set_hl(0, group, other)
      end
      vim.api.nvim_set_hl(0, 'IlluminatedCurWord', current)
    end

    set_colors()

    -- Reloading a colorscheme clears every highlight. The augroup keeps this
    -- from stacking duplicate autocmds when the file is re-sourced.
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('illuminate_colors', { clear = true }),
      callback = set_colors,
    })
  end,
}
