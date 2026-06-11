vim.opt_local.expandtab = false  -- Go uses tabs
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.commentstring = '//%s'

-- Format on save with organize imports (gopls)
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('go_format_' .. bufnr, { clear = true }),
  buffer = bufnr,
  callback = function()
    local params = vim.lsp.util.make_range_params(nil, 'utf-16')
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 1000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local clients = vim.lsp.get_clients({ id = cid })
          local enc = (clients[1] and clients[1].offset_encoding) or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})
