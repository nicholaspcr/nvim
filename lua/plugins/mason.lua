local function mason()
    require("mason").setup()
    require("mason-lspconfig").setup {
        automatic_enable = true
    }

    vim.lsp.config('tsserver', { settings = { completions = { completeFunctionCalls = true } } })
    vim.lsp.config('gopls', {
        cmd = { 'gopls', '--remote=auto', '-rpc.trace', '--debug=localhost:6060' },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            analyses = {
              unusedparams = true,
            },
          },
        },
    })
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        pattern = '*.go',
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          -- buf_request_sync defaults to a 1000ms timeout. Depending on your
          -- machine and codebase, you may want longer. Add an additional
          -- argument after params if you find that you have to write the file
          -- twice for changes to be saved.
          -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({ async = false })
        end
    })

    vim.lsp.config('clangd', {
       cmd = {
         'clangd',
         '--background-index',
         '--suggest-missing-includes',
         '--clang-tidy',
         '--header-insertion=iwyu',
       },
    })
    vim.lsp.config('rust_analyzer', {
      settings = {
         imports = {
           granularity = {
             group = 'module',
           },
           prefix = 'self',
         },
         cargo = {
           buildScripts = {
             enable = true,
           },
         },
         procMacro = {
           enable = true,
         },
       },
    })
    vim.lsp.config('lua_ls', {
       settings = {
         Lua = {
           completion = {
             callSnippet = "Replace"
           }
         }
       }
    })
    vim.lsp.config('marksman', {
       cmd = { "marksman", "server" },
       file_types = { "markdown", "markdown.mdx" },
       single_file_support = true,
    })
end



return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
    },
    config = mason,
}
