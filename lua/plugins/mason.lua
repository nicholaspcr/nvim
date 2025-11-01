local function mason()
    require("mason").setup()
    require("mason-lspconfig").setup {
        automatic_enable = true
    }

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.config('tsserver', { 
        capabilities = capabilities,
        settings = { completions = { completeFunctionCalls = true } } 
    })
    vim.lsp.config('gopls', {
        capabilities = capabilities,
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
          local params = vim.lsp.util.make_range_params(nil, "utf-16")
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({ async = true })
        end
    })

    vim.lsp.config('clangd', {
       capabilities = capabilities,
       cmd = {
         'clangd',
         '--background-index',
         '--suggest-missing-includes',
         '--clang-tidy',
         '--header-insertion=iwyu',
       },
    })
    vim.lsp.config('rust_analyzer', {
      capabilities = capabilities,
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
       capabilities = capabilities,
       settings = {
         Lua = {
           completion = {
             callSnippet = "Replace"
           }
         }
       }
    })
    vim.lsp.config('marksman', {
       capabilities = capabilities,
       cmd = { "marksman", "server" },
       file_types = { "markdown", "markdown.mdx" },
       single_file_support = true,
    })

    vim.lsp.config('pylsp', {
        capabilities = capabilities,
        settings = {
            pylsp = {
                plugins = {
                    -- formatter options
                    black = { enabled = true },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    -- linter options
                    pylint = { enabled = true },
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    -- type checker
                    pylsp_mypy = { enabled = true },
                    -- auto-completion options
                    jedi_completion = { fuzzy = true },
                    -- import sorting
                    pyls_isort = { enabled = true },
                },
            },
        }
    })

end



return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = mason,
}
