local opt = vim.opt
-- stdpath('cache') already honours $XDG_CACHE_HOME; don't hardcode ~/.cache.
local cache_dir = vim.fn.stdpath('cache') .. '/'

opt.termguicolors = true
opt.virtualedit = 'block'
-- Clipboard: prefer macOS pbcopy/pbpaste (works in or out of tmux and bridges
-- to the system pasteboard), fall back to OSC52 over SSH/non-mac.
if vim.fn.has('mac') == 1 then
  vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = true,
  }
else
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end
opt.clipboard = 'unnamedplus'
opt.wildignorecase = true
opt.swapfile = false
opt.undodir = cache_dir .. 'undo/'
opt.viewdir = cache_dir .. 'view/'
opt.spellfile = cache_dir .. 'spell/en.utf-8.add'

-- Neovim creates 'undodir' on demand but not 'viewdir' or the parent of
-- 'spellfile', so :mkview and zg fail with E484 on a fresh machine.
-- pcall: mkdir throws E739 if the path already exists as a regular file, and
-- an uncaught error here would abort the rest of this file.
for _, dir in ipairs({ 'undo/', 'view/', 'spell/' }) do
  pcall(vim.fn.mkdir, cache_dir .. dir, 'p')
end
opt.history = 2000
opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true

if vim.fn.executable('rg') == 1 then
  opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

opt.completeopt = 'menu,menuone,noselect'
opt.showmode = false
opt.shortmess = 'aoOTIcF'
opt.scrolloff = 8
opt.sidescrolloff = 5
opt.showtabline = 1
opt.winwidth = 30
opt.pumheight = 15

opt.cmdheight = 1
opt.laststatus = 3
opt.list = true
opt.pumblend = 10
opt.winblend = 10
opt.undofile = true
opt.confirm = true
opt.smoothscroll = true
opt.splitkeep = 'screen'
opt.splitright = true
opt.splitbelow = true
opt.jumpoptions = 'stack'
opt.inccommand = 'split'

opt.smarttab = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- highlight
opt.hlsearch = true

-- cursor
opt.cursorline = true

-- wrap
opt.linebreak = true
opt.whichwrap = 'h,l,<,>,[,],~'
opt.breakindentopt = 'shift:2,min:20'
opt.showbreak = '↳ '

opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99
opt.foldmethod = 'expr'

opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.spelloptions = 'camel'

opt.conceallevel = 1

-- Colorcolumn configuration
-- Set via NVIM_COLUMN environment variable (defaults to 120)
-- Example: export NVIM_COLUMN=80
local column = os.getenv('NVIM_COLUMN')
if column == nil then
  opt.textwidth = 120
else
  opt.textwidth = tonumber(column)
end
opt.colorcolumn = '+1'

-- Spell checking is configured per-filetype in after/ftplugin/
-- (markdown.lua and text.lua)

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 150 })
  end,
})

-- Transparent background is handled by gruvbox transparent_mode
