-- LSP server management with Mason
-- Versions: Using latest for Mason plugins (recommended by maintainers)
local function mason()
    local mason_ok, mason = pcall(require, "mason")
    if not mason_ok then
        vim.notify("Failed to load mason", vim.log.levels.ERROR)
        return
    end

    local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lsp_ok then
        vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
        return
    end

    mason.setup()
    mason_lspconfig.setup()

    -- Get capabilities from cmp_nvim_lsp
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Buffer-local keymaps for LSP
    local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Enable inlay hints if supported
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            vim.keymap.set('n', '<leader>ih', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, { buffer = bufnr, desc = 'Toggle inlay hints' })
        end

        -- Navigation
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        -- Information
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

        -- Actions
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    end

    -- TypeScript/JavaScript
    vim.lsp.enable('ts_ls')
    vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            completions = {
                completeFunctionCalls = true
            }
        }
    })

    -- Go with formatting on save
    vim.lsp.enable('gopls')
    vim.lsp.config('gopls', {
        capabilities = capabilities,
        on_attach = on_attach,
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

    -- Go formatting autocmd with organize imports
    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
            local params = vim.lsp.util.make_range_params(nil, "utf-16")
            params.context = { only = { "source.organizeImports" } }
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
            for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                    end
                end
            end
            -- Format synchronously to ensure it completes before save
            vim.lsp.buf.format({ async = false })
        end
    })

    -- C/C++
    vim.lsp.enable('clangd')
    vim.lsp.config('clangd', {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
            'clangd',
            '--background-index',
            '--suggest-missing-includes',
            '--clang-tidy',
            '--header-insertion=iwyu',
        },
    })

    -- Rust
    vim.lsp.enable('rust_analyzer')
    vim.lsp.config('rust_analyzer', {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            ['rust-analyzer'] = {
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
        },
    })

    -- Lua
    vim.lsp.enable('lua_ls')
    vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace"
                }
            }
        }
    })

    -- Markdown
    vim.lsp.enable('marksman')
    vim.lsp.config('marksman', {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "marksman", "server" },
        filetypes = { "markdown", "markdown.mdx" },
        single_file_support = true,
    })

    -- Python
    vim.lsp.enable('pylsp')
    vim.lsp.config('pylsp', {
        capabilities = capabilities,
        on_attach = on_attach,
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
