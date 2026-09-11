-- LSP wiring: completion capabilities, per-server settings from lua/lsp/, and
-- the buffer-local keymaps installed when a client attaches.
local M = {}

local function keymaps(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local bufnr = ev.buf

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Inlay hints, where the server offers them
  if client and client:supports_method('textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    map('n', '<Leader>ih', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, 'Toggle inlay hints')
  end

  -- Neovim's own default keys, rebound to telescope pickers. Stock Neovim
  -- sends these to the quickfix list; keeping the bindings and swapping only
  -- the handler means no relearning and no new prefix ambiguity, because
  -- nothing extends grr/gri/grt/gO/<C-]>.
  --
  -- Left as Neovim set them: grn (rename), grx (codelens), K (hover),
  -- <C-s> (signature help), and 'tagfunc'/'omnifunc'. gra (code action) goes
  -- through vim.ui.select, which telescope-ui-select routes into a picker.
  local function picker(name)
    return function()
      require('telescope.builtin')[name]()
    end
  end
  -- gd alongside Neovim's <C-]>: nothing extends it, so it costs no
  -- 'timeoutlen' wait, and it shadows only the builtin "go to local
  -- declaration", which the LSP definition supersedes.
  map('n', 'gd', picker('lsp_definitions'), 'Definition')
  map('n', '<C-]>', picker('lsp_definitions'), 'Definition')
  map('n', 'grr', picker('lsp_references'), 'References')
  map('n', 'gri', picker('lsp_implementations'), 'Implementation')
  map('n', 'grt', picker('lsp_type_definitions'), 'Type definition')
  map('n', 'gO', picker('lsp_document_symbols'), 'Document symbols')
end

--- Apply a server's source.organizeImports code action synchronously.
--- gopls exposes import management as a code action rather than as formatting,
--- so `gofmt` alone will not add or drop an import. Called from the
--- format_on_save hook in plugins/conform.lua, which runs it before formatting.
---@param bufnr integer
---@param name string LSP client name
function M.organize_imports(bufnr, name)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = name })[1]
  if not client then
    return
  end

  -- Built from bufnr rather than via make_range_params(), whose first argument
  -- is a *window*: that would resolve the document from whatever buffer is in
  -- the current window and organise the imports of the wrong file.
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = { line = 0, character = 0 },
      ['end'] = { line = 0, character = 0 },
    },
    context = { only = { 'source.organizeImports' }, diagnostics = {} },
  }

  local response = client:request_sync('textDocument/codeAction', params, 1000, bufnr)
  if not response or response.err then
    -- Most often a cold server missing the 1000ms budget on the first save.
    -- Say so rather than dropping imports silently.
    vim.notify(
      ('%s: organize imports failed (%s)'):format(name, response and vim.inspect(response.err) or 'timed out'),
      vim.log.levels.WARN
    )
    return
  end

  for _, action in ipairs(response.result or {}) do
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

---@param servers table<string, table> server name -> settings
function M.setup(servers)
  -- blink.cmp registers these from its own plugin/ file, but only once it
  -- loads. It is a dependency of the mason spec so that always happens before
  -- the first client starts; setting them here keeps that independent of
  -- lazy-loading order.
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),
  })

  for name, settings in pairs(servers) do
    vim.lsp.config(name, settings)
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
    callback = keymaps,
  })
end

return M
