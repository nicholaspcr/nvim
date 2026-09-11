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

  -- Navigation, routed through telescope so results are pickable.
  -- These replace Neovim's gr* defaults, which M.setup() deletes: leaving
  -- those in place makes the builtin gr{char} a partial match and stalls it
  -- for 'timeoutlen' on every press (:h map-ambiguous).
  local function picker(name)
    return function()
      require('telescope.builtin')[name]()
    end
  end
  map('n', 'gd', picker('lsp_definitions'), 'Definition')
  map('n', 'gD', picker('lsp_type_definitions'), 'Type definition')
  map('n', 'gi', picker('lsp_implementations'), 'Implementation')
  map('n', 'gr', picker('lsp_references'), 'References')

  -- Information
  map('n', 'K', vim.lsp.buf.hover, 'Hover')
  map({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

  -- Actions
  map('n', '<Leader>rn', vim.lsp.buf.rename, 'Rename symbol')
  map('n', '<Leader>ca', vim.lsp.buf.code_action, 'Code action')
  map('n', '<Leader>cl', vim.lsp.codelens.run, 'Run codelens')
end

-- Neovim 0.11+ maps these unconditionally at startup. Every one of them
-- extends 'gr', so the builtin gr{char} virtual replace cannot fire until
-- 'timeoutlen' has elapsed. The equivalents are bound above, on keys that
-- nothing extends.
local DEFAULT_LSP_MAPS = {
  { 'n', 'grn' },
  { { 'n', 'x' }, 'gra' },
  { 'n', 'grx' },
  { 'n', 'grr' },
  { 'n', 'gri' },
  { 'n', 'grt' },
}

local function drop_default_maps()
  for _, spec in ipairs(DEFAULT_LSP_MAPS) do
    -- pcall: harmless if a future Neovim stops defining one of these.
    pcall(vim.keymap.del, spec[1], spec[2])
  end
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

  drop_default_maps()

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
    callback = keymaps,
  })
end

return M
