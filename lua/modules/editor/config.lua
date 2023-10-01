local config = {}

function config.nvim_treesitter()
  vim.api.nvim_command('set foldmethod=expr')
  vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    ignore_install = { 'phpdoc' },
    highlight = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },
  })
end

function config.nvim_treesitter_context()
  require('treesitter-context').setup({
    enable = true,
    max_lines = 3,
  })
end


function config.neoformat()
  -- TODO: Allow for it to take repository configuration
  --vim.cmd("au BufWritePre *.js Neoformat")
  --vim.cmd("au BufWritePre *.ts Neoformat")
end


return config
