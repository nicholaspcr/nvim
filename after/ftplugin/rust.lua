vim.opt_local.commentstring = '//%s'
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.smartindent = true
vim.opt_local.tabstop = 4
vim.opt_local.cindent = false
vim.opt_local.expandtab = true

-- Format on save (rust-analyzer)
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('rust_format_' .. bufnr, { clear = true }),
  buffer = bufnr,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
