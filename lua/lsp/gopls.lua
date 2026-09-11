-- Go. Format-on-save with organize-imports is handled by conform.nvim.
--
-- Settings and analyzer defaults verified against the installed binary with
-- `gopls api-json`, not the docs, which lag behind releases.
return {
  settings = {
    gopls = {
      buildFlags = { '-tags=database,integration,tti' },
      usePlaceholders = true,

      -- Off by default and worth the cost: adds the staticcheck suite
      -- (SA/ST/S/QF), roughly 83 checks beyond the base analyzers.
      staticcheck = true,

      -- Glob form, per the directoryFilters docs; the default is
      -- {'-**/node_modules'} and setting this key replaces it wholesale.
      directoryFilters = {
        '-**/node_modules',
        '-**/vendor',
      },

      -- No `analyses` block: unusedparams, nilness, unusedwrite and
      -- unusedvariable are all on by default in v0.23. The notable
      -- off-by-default ones are deliberately left off -- `shadow` has a high
      -- false-positive rate and `fieldalignment` trades readability for
      -- struct packing.

      -- vim.lsp.inlay_hint.enable() in lua/core/lsp.lua only asks the server
      -- for hints; gopls emits none until these are turned on individually.
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
