-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.lang.config')

plugin({
  'nvim-treesitter/nvim-treesitter',
  event = 'BufRead',
  run = ':TSUpdate',
  after = 'telescope.nvim',
  config = conf.nvim_treesitter,
})

plugin({ 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' })

--plugin({
--  'nvim-orgmode/orgmode',
--  ft = {'org'},
--  after = 'nvim-treesitter',
--  config = function ()
--    require('orgmode').setup{
--      org_agenda_files = { '~/Workspace/org/*' },
--      org_default_notes_file = '~/Workspace/org/refile.org',
--      org_todo_keywords = {'TODO', 'INPROGRESS', 'BLOCKED', 'DONE'},
--      mappings = {
--        global = {
--          org_agenda = 'gA',
--          org_capture = 'gC',
--        },
--        capture = {
--          org_capture_finalize = '<Leader>w',
--          org_capture_refile = 'R',
--          org_capture_kill = 'Q'
--        },
--      }
--    }
--  end,
--})
--
--plugin({
--  'akinsho/org-bullets.nvim',
--  config = function()
--    require('org-bullets').setup()
--  end
--})
--
--plugin({
--  'lukas-reineke/headlines.nvim',
--  config = function()
--      require('headlines').setup()
--  end,
--})
