local config = {}


function config.nvim_cmp()
  local lspconfig = require('lspconfig')
  require("mason").setup()
  require("mason-lspconfig").setup()

  local cmp = require('cmp')
  local select_opts = {behavior = cmp.SelectBehavior.Select}

  cmp.setup({
    preselect = cmp.PreselectMode.Item,
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if cmp.visible() then
          cmp.select_next_item(select_opts)
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end, {'i', 's'})
    }),
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
    },
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  capabilities.offsetEncoding = 'utf-8'

  local signs = {
    Error = ' ',
    Warn = ' ',
    Info = ' ',
    Hint = ' ',
  }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    virtual_text = {
      prefix = '🔥',
      source = true,
    },
  })

  local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end

  -- See :help mason-lspconfig-dynamic-server-setup
  require('mason-lspconfig').setup_handlers({
    function(server)
      lspconfig[server].setup({capabilities = capabilities})
    end,
    ['tsserver'] = function()
      require("lspconfig").tsserver.setup({settings = {completions = {completeFunctionCalls = true}}})
    end,
    ['gopls'] = function()
      require("lspconfig").gopls.setup({
        on_attach = on_attach,
        cmd = { 'gopls', '--remote=auto', '-rpc.trace', '--debug=localhost:6060' },
        capabilities = capabilities,
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          gofumpt = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
        },
      })
    end,
    ['clangd'] = function()
      require("lspconfig").clangd.setup({
        on_attach = on_attach,
        cmd = {
          'clangd',
          '--background-index',
          '--suggest-missing-includes',
          '--clang-tidy',
          '--header-insertion=iwyu',
        },
      })
    end,
    ['rust_analyzer'] = function()
      require("lspconfig").rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
    end,
    ['lua_ls'] = function()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace"
            }
          }
        }
      })
    end,
    ['marksman'] = function()
      require("lspconfig").marksman.setup({
        cmd = { "marksman", "server" },
        file_types = { "markdown", "markdown.mdx" },
        single_file_support = true,
      })
    end,
  })
end

function config.dap_ui()
  require('dapui').setup({})

    vim.g.mapleader = ' '
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent

    nmap({
      { '<Leader>dt', cmd(':lua require("dapui").toggle()'), opts(noremap, silent) },
      { '<Leader>db', cmd('DapToggleBreakpoint'), opts(noremap, silent) },
      { '<Leader>dc', cmd('DapContinue'), opts(noremap, silent) },
      { '<Leader>dr', cmd(':lua require("dapui").open({reset=true})'), opts(noremap, silent) },
    })
end

function config.nvim_dap_go()
    require('dap-go').setup({})

    vim.g.mapleader = ' '
    local keymap = require('core.keymap')
    local nmap = keymap.nmap
    local cmd, opts = keymap.cmd, keymap.new_opts
    local noremap, silent =  keymap.noremap, keymap.silent

    nmap({
      { '<Leader>dgt', cmd(":lua require('dap-go').debug_test()"), opts(noremap, silent) },
      { '<Leader>dgl', cmd(":lua require('dap-go').debug_last_test()"), opts(noremap, silent) },
    })
end

function config.neodev()
  require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
  })
end

function config.lua_snip()
  local ls = require('luasnip')
  local types = require('luasnip.util.types')
  ls.config.set_config({
    history = true,
    enable_autosnippets = true,
    updateevents = 'TextChanged,TextChangedI',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '<- choiceNode', 'Comment' } },
        },
      },
    },
  })
  require('luasnip.loaders.from_lua').lazy_load({ paths = vim.fn.stdpath('config') .. '/snippets' })
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = { './snippets/' },
  })
end

return config
