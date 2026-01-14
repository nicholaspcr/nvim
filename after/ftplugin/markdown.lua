vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

-- Enable spell checking for markdown files
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- Concealment settings for cleaner markdown display
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'

-- Heading navigation
vim.keymap.set('n', ']]', function()
  vim.fn.search('^#', 'W')
end, { buffer = true, desc = 'Next heading' })

vim.keymap.set('n', '[[', function()
  vim.fn.search('^#', 'bW')
end, { buffer = true, desc = 'Previous heading' })

-- Spell toggle
vim.keymap.set('n', '<Leader>sp', ':setlocal spell!<CR>', { buffer = true, desc = 'Toggle spell' })
