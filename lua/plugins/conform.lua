-- Formatting. Replaces the hand-rolled BufWritePre autocmds that used to live
-- in after/ftplugin/go.lua and after/ftplugin/rust.lua: those blocked the save
-- on a 1000ms synchronous buf_request_sync and allocated an augroup per buffer.
--
-- Every filetype falls back to LSP formatting when its formatter binary is
-- missing, so a machine without prettier or goimports still formats.

-- Only these save automatically, matching the previous behaviour.
local format_on_save_filetypes = {
  go = true,
  rust = true,
}

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<Leader>fw',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      -- Imports are handled separately by the gopls source.organizeImports
      -- code action below, so this only needs the formatter.
      go = { 'gofmt' },
      rust = { 'rustfmt' },
      lua = { 'stylua' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
      local filetype = vim.bo[bufnr].filetype
      if not format_on_save_filetypes[filetype] then
        return nil
      end
      -- This hook runs immediately before the formatter, which is the order
      -- goimports would use: fix the import block, then format the result.
      if filetype == 'go' then
        require('core.lsp').organize_imports(bufnr, 'gopls')
      end
      return { timeout_ms = 2000, lsp_format = 'fallback' }
    end,
  },
}
