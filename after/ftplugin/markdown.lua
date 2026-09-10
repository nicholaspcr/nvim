vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'

-- Conceal links and emphasis markers (global conceallevel is 1).
-- plugins/render_markdown.lua restores these when its render is toggled off.
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'nc'

-- Heading navigation
vim.keymap.set('n', ']]', function()
  vim.fn.search('^#', 'W')
end, { buffer = true, desc = 'Next heading' })

vim.keymap.set('n', '[[', function()
  vim.fn.search('^#', 'bW')
end, { buffer = true, desc = 'Previous heading' })

vim.keymap.set('n', '<Leader>sp', '<cmd>setlocal spell!<CR>', { buffer = true, desc = 'Toggle spell' })
