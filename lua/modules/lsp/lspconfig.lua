local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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


local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

lspconfig.gopls.setup({
  on_attach = on_attach,
  flags = lsp_flags,
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


lspconfig.clangd.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  cmd = {
    'clangd',
    '--background-index',
    '--suggest-missing-includes',
    '--clang-tidy',
    '--header-insertion=iwyu',
  },
})

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
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

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

lspconfig.marksman.setup({
  cmd = { "marksman", "server" },
  file_types = { "markdown", "markdown.mdx" },
  single_file_support = true,
})

local servers = {
  'dockerls',
  'pyright',
  'bashls',
  'zls',
  'tsserver',
  'gopls',
  'marksman',
}

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = on_attach,
    flags = lsp_flags,
  })
end
