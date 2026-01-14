vim.opt_local.commentstring = '//%s'
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.smartindent = true
vim.opt_local.tabstop = 4
vim.opt_local.cindent = false
vim.opt_local.expandtab = true

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = 0,
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
