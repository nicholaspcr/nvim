local keymap = require('core.keymap')
local nmap, imap, cmap, tmap = keymap.nmap, keymap.imap, keymap.cmap, keymap.tmap
local expr = keymap.expr
local opts = keymap.new_opts
local silent, noremap = keymap.silent, keymap.noremap
local cmd = keymap.cmd

-- noremal remap
nmap({
  -- close buffer
  { '<C-x>k', cmd('bdelete') },
  -- save
  { '<C-s>', cmd('write') },
  -- buffer jump
  { ']b', cmd('bn') },
  { '[b', cmd('bp') },
  -- remove trailing white space
  { '<Leader>t', cmd('TrimTrailingWhitespace') },
  -- resize window
  { '<A-[>', cmd('vertical resize -5') },
  { '<A-]>', cmd('vertical resize +5') },
})

-- insertmode remap
imap({
  { '<C-w>', '<C-[>diwa' },
  { '<C-h>', '<Bs>' },
  { '<C-d>', '<Del>' },
  { '<C-u>', '<C-G>u<C-u>' },
  { '<C-b>', '<Left>' },
  { '<C-f>', '<Right>' },
  { '<C-a>', '<Esc>^i' },
  { '<C-j>', '<Esc>o' },
  { '<C-k>', '<Esc>O' },
  { '<C-s>', '<ESC>:w<CR>' },
  {
    '<C-e>',
    function()
      return vim.fn.pumvisible() == 1 and '<C-e>' or '<End>'
    end,
    opts(expr),
  },
})

-- commandline remap
cmap({
  { '<C-b>', '<Left>' },
  { '<C-f>', '<Right>' },
  { '<C-a>', '<Home>' },
  { '<C-e>', '<End>' },
  { '<C-d>', '<Del>' },
  { '<C-h>', '<BS>' },
})

tmap({ '<Esc>', [[<C-\><C-n>]] })


