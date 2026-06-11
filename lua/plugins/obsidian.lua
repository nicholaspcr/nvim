-- Obsidian vault integration (community fork of epwalsh/obsidian.nvim).
-- Note completion/links/tags are provided via the plugin's in-process LSP,
-- which blink.cmp consumes through its 'lsp' source automatically.
local function obsidian()
  -- Auto-save for notes
  vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
    group = vim.api.nvim_create_augroup('obsidian_autosave', { clear = true }),
    pattern = vim.fn.expand('~/notes') .. '/**/*.md',
    callback = function()
      if vim.bo.modified then
        vim.cmd('silent! write')
      end
    end,
    desc = 'Auto-save notes',
  })

  require('obsidian').setup({
    legacy_commands = false, -- use :Obsidian <subcommand> only

    workspaces = {
      {
        name = 'notes',
        path = '~/notes',
      },
    },
    notes_subdir = 'notes',
    new_notes_location = 'notes_subdir',
    log_level = vim.log.levels.INFO,

    templates = {
      folder = 'templates',
      date_format = 'dddd, MMMM D, YYYY',
      time_format = 'HH:mm',
    },

    daily_notes = {
      folder = 'daily',
      date_format = 'YYYY-MM-DD',
      alias_format = 'MMMM D, YYYY',
      template = 'daily.md',
      default_tags = { 'daily' },
    },

    -- Customize how names/IDs for new notes are created, e.g.
    -- '1657296016-my-new-note.md' for a note titled 'My new note'.
    note_id_func = function(title)
      local suffix = ''
      if title ~= nil then
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    link = {
      style = 'markdown',
    },

    picker = {
      name = 'telescope.nvim',
    },
  })
end

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  -- Loads for markdown buffers, on any of the keys below, or on direct
  -- :Obsidian command invocation — without paying the cost at startup.
  ft = 'markdown',
  cmd = { 'Obsidian' },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<Leader>on', '<cmd>Obsidian new<CR>', desc = 'New note' },
    { '<Leader>ow', '<cmd>Obsidian workspace<CR>', desc = 'Workspace' },
    { '<Leader>ot', '<cmd>Obsidian today<CR>', desc = 'Today' },
    { '<Leader>oy', '<cmd>Obsidian yesterday<CR>', desc = 'Yesterday' },
    { '<Leader>os', '<cmd>Obsidian tags<CR>', desc = 'Search tags' },
    { '<Leader>of', '<cmd>Obsidian quick_switch<CR>', desc = 'Find notes' },
    { '<Leader>ob', '<cmd>Obsidian backlinks<CR>', desc = 'Backlinks' },
    { '<Leader>ol', '<cmd>Obsidian links<CR>', desc = 'Outgoing links' },
    { '<Leader>oR', '<cmd>Obsidian rename<CR>', desc = 'Rename note' },
    { '<Leader>oT', '<cmd>Obsidian template<CR>', desc = 'Insert template' },
    { '<Leader>ch', '<cmd>Obsidian toggle_checkbox<CR>', desc = 'Toggle checkbox' },
    {
      '<Leader>og',
      function()
        require('telescope.builtin').live_grep({
          cwd = vim.fn.expand('~/notes'),
          prompt_title = 'Search Notes Content',
        })
      end,
      desc = 'Grep notes',
    },
    {
      '<Leader>od',
      function()
        require('telescope.builtin').find_files({
          cwd = vim.fn.expand('~/notes/daily'),
          prompt_title = 'Daily Notes',
          sorting_strategy = 'descending',
        })
      end,
      desc = 'Daily notes',
    },
    {
      '<Leader>or',
      function()
        require('telescope.builtin').find_files({
          cwd = vim.fn.expand('~/notes/notes'),
          prompt_title = 'Recent Notes (7d)',
          find_command = { 'fd', '--type', 'f', '-e', 'md', '--changed-within', '7d' },
        })
      end,
      desc = 'Recent notes',
    },
  },
  config = obsidian,
}
