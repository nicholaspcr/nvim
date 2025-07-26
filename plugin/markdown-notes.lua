-- It's good practice to wrap plugin setup in a group to avoid errors
-- if the module doesn't exist.
local status_ok, markdown_notes = pcall(require, 'markdown-notes')
if not status_ok then
  return
end

-- Call the setup function (users can configure this in their init.lua)
markdown_notes.setup()

-- Command to create a new daily note
vim.api.nvim_create_user_command(
  'DailyNote',
  function()
    markdown_notes.create_from_template('daily')
  end,
  { nargs = 0 }
)

-- Command to create a new todo note, takes a title as an argument
vim.api.nvim_create_user_command(
  'Todo',
  function(opts)
    markdown_notes.create_from_template('todo', opts.args)
  end,
  { nargs = 1, complete = 'file' }
)

vim.api.nvim_create_user_command(
  'TodoWeek',
  function()
    markdown_notes.show_this_week_todos()
  end,
  { nargs = 0 }
)
