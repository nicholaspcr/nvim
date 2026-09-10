-- Treesitter parser/query management (main rewrite).
-- Highlighting, folds, and indentation are Neovim built-ins enabled per
-- buffer in the FileType autocmd below; textobjects live in
-- plugins/nvim_treesitter_textobjects.lua.
local parsers = {
  'bash',
  'c',
  'go',
  'inko',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'proto',
  'python',
  'query',
  'readline',
  'regex',
  'rust',
  'sql',
  'terraform',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  'html',
  'css',
  'tsx',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- the main branch does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    -- install() is an async no-op for parsers already present, but it still
    -- walks the whole list on every startup. Diff against what is installed
    -- and only call it when something is actually missing.
    local function install_missing()
      local installed = {}
      for _, name in ipairs(require('nvim-treesitter.config').get_installed('parsers')) do
        installed[name] = true
      end

      local missing = vim.tbl_filter(function(name)
        return not installed[name]
      end, parsers)

      if #missing > 0 then
        require('nvim-treesitter').install(missing)
      end
      return missing
    end

    install_missing()

    vim.api.nvim_create_user_command('TSEnsureInstalled', function()
      local missing = install_missing()
      vim.notify(#missing > 0 and ('Installing parsers: ' .. table.concat(missing, ', ')) or 'All parsers installed')
    end, { desc = 'Install any parser from the list that is missing' })

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
