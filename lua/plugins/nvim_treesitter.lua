-- Treesitter parser/query management (main rewrite).
-- Highlighting, folds, and indentation are Neovim built-ins enabled per
-- buffer in the FileType autocmd below; textobjects live in
-- plugins/nvim_treesitter_textobjects.lua.
local parsers = {
  "bash",
  "c",
  "go",
  "inko",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "proto",
  "python",
  "query",
  "readline",
  "regex",
  "rust",
  "sql",
  "terraform",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "html",
  "css",
  "tsx",
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- the main branch does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    -- Async no-op for parsers that are already installed
    require('nvim-treesitter').install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_features', { clear = true }),
      callback = function(args)
        -- No parser for this filetype: skip silently
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
        -- Treesitter-based indentation (experimental upstream)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
