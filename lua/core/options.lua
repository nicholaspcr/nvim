local opt = vim.opt
local cache_dir = vim.env.HOME .. '/.cache/nvim/'

-- Read background from dotfiles theme file, fallback to 'dark'
local function get_theme()
  local theme_file = vim.fn.expand('~/dotfiles/.current_theme')
  local f = io.open(theme_file, 'r')
  if f then
    local theme = f:read('*l')
    f:close()
    if theme == 'light' then return 'light' end
  end
  return 'dark'
end

opt.background = get_theme()

-- Auto-switch background when returning to neovim after theme toggle
vim.api.nvim_create_autocmd('FocusGained', {
  group = vim.api.nvim_create_augroup('theme_sync', { clear = true }),
  callback = function()
    local bg = get_theme()
    if vim.o.background ~= bg then
      vim.o.background = bg
    end
  end,
})
opt.termguicolors = true
opt.virtualedit = 'block'
opt.clipboard = 'unnamedplus'
opt.wildignorecase = true
opt.swapfile = false
opt.undodir = cache_dir .. 'undo/'
opt.backupdir = cache_dir .. 'backup/'
opt.viewdir = cache_dir .. 'view/'
opt.spellfile = cache_dir .. 'spell/en.utf-8.add'
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

opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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
local column = os.getenv("NVIM_COLUMN")
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
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
  end,
})

-- Transparent background is handled by gruvbox transparent_mode
