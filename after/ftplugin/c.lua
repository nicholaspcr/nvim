-- The builtin c ftplugin uses /* */; everything else matches the globals
-- (expandtab, tabstop and shiftwidth in lua/core/options.lua) or is driven by
-- the treesitter indentexpr set in plugins/nvim_treesitter.lua.
vim.opt_local.commentstring = '//%s'
