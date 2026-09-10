-- Diagnostic display. Keymaps live in lua/core/mappings.lua; this is only
-- how diagnostics are rendered.
local M = {}

function M.setup()
  vim.diagnostic.config({
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    virtual_text = {
      source = true,
    },
  })
end

return M
