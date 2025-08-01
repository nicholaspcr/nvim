local opt = vim.opt
local cache_dir = vim.env.HOME .. '/.cache/nvim/'

local theme_file_path = vim.fn.expand('~/.current_theme')
local file = io.open(theme_file_path, 'r')
if file then
  local theme = file:read('*a')
  file:close()
  opt.background = vim.trim(theme)
else
  opt.background = 'dark'
end

opt.termguicolors = true
opt.hidden = true
opt.magic = true
opt.virtualedit = 'block'
opt.clipboard = 'unnamedplus'
opt.wildignorecase = true
opt.swapfile = false
opt.directory = cache_dir .. 'swap/'
opt.undodir = cache_dir .. 'undo/'
opt.backupdir = cache_dir .. 'backup/'
opt.viewdir = cache_dir .. 'view/'
opt.spellfile = cache_dir .. 'spell/en.uft-8.add'
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
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.ruler = false
opt.showtabline = 1
opt.winwidth = 30
opt.pumheight = 15
opt.showcmd = false

opt.cmdheight = 1
opt.laststatus = 3
opt.list = true
opt.pumblend = 10
opt.winblend = 10
opt.undofile = true

opt.smarttab = true
opt.expandtab = true
opt.autoindent = true
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

opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 5
opt.foldmethod = 'expr'

opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.spelloptions = 'camel'

opt.conceallevel = 1

local column = os.getenv("NVIM_COLUMN")
if column == nil then
  opt.textwidth = 120
else
  opt.textwidth = tonumber(column)
end
opt.colorcolumn = '+1'

if vim.loop.os_uname().sysname == 'Darwin' then
  vim.g.clipboard = {
    name = 'macOS-clipboard',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 0,
  }
  vim.g.python_host_prog = '/usr/bin/python'
  vim.g.python3_host_prog = '/usr/local/bin/python3'
end


vim.cmd("setlocal spell spelllang=en_us")
vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank {higroup='IncSearch', timeout=150}")
vim.cmd(":highlight Normal guibg=none")
