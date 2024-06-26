local keymap = require('core.keymap')
local nmap, imap, cmap, xmap = keymap.nmap, keymap.imap, keymap.cmap, keymap.xmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

-- Use space as leader key
vim.g.mapleader = ' '

-- leaderkey
nmap({ ' ', '', opts(noremap) })
xmap({ ' ', '', opts(noremap) })

-- usage example
nmap({
  -- noremal remap
  -- close buffer
  { '<C-x>k', cmd('bdelete'), opts(noremap, silent) },
  { '<C-x>p', cmd('let @+=expand("%:p")'), opts(noremap, silent) },

  -- save
  { '<C-s>', cmd('write'), opts(noremap) },
  -- yank
  { 'Y', 'y$', opts(noremap) },
  -- buffer jump
  { ']b', cmd('bn'), opts(noremap) },
  { '[b', cmd('bp'), opts(noremap) },
  -- remove trailing white space
  { '<Leader>tw', cmd('TrimTrailingWhitespace'), opts(noremap) },
  { '<Leader><CR>', ':noh<CR>', opts(noremap,silent) },
  -- Tab related
  { '<Leader>tn', cmd('tabnew'), opts(noremap) },
  { '<Leader>tc', cmd('tabclose'), opts(noremap) },
  -- Movement related
  { '<C-d>', '<C-d>zz', opts(noremap) },
  { '<C-u>', '<C-u>zz', opts(noremap) },
})



imap({
  -- insert mode
  { '<C-h>', '<Bs>', opts(noremap) },
  { '<C-e>', '<End>', opts(noremap) },
})

-- usage of plugins
nmap({
  -- plugin manager: Lazy.nvim
  { '<Leader>pu', cmd('Lazy update'), opts(noremap, silent) },
  { '<Leader>pi', cmd('Lazy install'), opts(noremap, silent) },

  {'gd', cmd('Telescope lsp_definitions'), opts(noremap,silent)},
  {
    'gr',
    function () require('telescope.builtin').lsp_references({ show_line = true, include_declaration = true }) end,
    opts(noremap,silent),
  },
  {'<Leader>gr', vim.lsp.buf.references, opts(noremap,silent)},
  {'K', vim.lsp.buf.hover, opts(noremap,silent)},
  {'gi', cmd('Telescope lsp_implementations'), opts(noremap,silent)},
  -- {'<C-k>', vim.lsp.buf.signature_help, opts(noremap,silent)},
  {'<Leader>D', cmd('Telescope lsp_type_definitions'), opts(noremap,silent)},
  {'<Leader>rn', vim.lsp.buf.rename, opts(noremap,silent)},
  {'<Leader>ca', vim.lsp.buf.code_action, opts(noremap,silent)},
})
