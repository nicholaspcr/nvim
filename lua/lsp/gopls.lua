-- Go. Format-on-save with organize-imports is handled by conform.nvim.
return {
  settings = {
    gopls = {
      buildFlags = { '-tags=database,integration,tti' },
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = false,
      directoryFilters = {
        '-vendor',
        '-node_modules',
      },
      analyses = {
        unusedparams = true,
      },
    },
  },
}
