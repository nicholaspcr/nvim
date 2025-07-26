-- lua/markdown-notes/init.lua

local M = {}

-- Default configuration
M.config = {
  notes_dir = vim.fn.expand('~/notes'),
  template_dir = vim.fn.expand('~/.config/nvim/template'),
  date_format = '%Y-%m-%d', -- Daily note format
  week_format = '%Y-W%W',
}

-- The setup function allows users to override the defaults
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

-- The main function to create a new note from a template
function M.create_from_template(template_name, note_title)
  -- 1. Define paths
  local template_path = M.config.template_dir .. '/' .. template_name .. '.md'
  local date_str = vim.fn.strftime(M.config.date_format)
  local file_name = (template_name == 'daily' and date_str or note_title) .. '.md'
  local note_path = M.config.notes_dir .. '/' .. file_name

  -- 2. Check if the notes directory exists
  if vim.fn.isdirectory(M.config.notes_dir) == 0 then
    vim.fn.mkdir(M.config.notes_dir, 'p')
    vim.notify('Created notes directory: ' .. M.config.notes_dir, vim.log.levels.INFO)
  end

  -- 3. Read the template file
  local template_content = vim.fn.readfile(template_path)
  if vim.v.shell_error ~= 0 then
    vim.notify('Template not found: ' .. template_path, vim.log.levels.ERROR)
    return
  end

  -- 4. Replace placeholders (add more as you need)
  local new_content = table.concat(template_content, '\n')
  new_content = new_content:gsub('{{date}}', date_str)
  new_content = new_content:gsub('{{title}}', note_title or 'New TODO')

  -- 5. Create and open the new note
  vim.cmd('edit ' .. note_path)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(new_content, '\n'))
  vim.notify('Created new note: ' .. note_path)
end

function M.show_this_week_todos()
  local notes_pattern = M.config.notes_dir .. '/**/*.md'
  local files = vim.fn.glob(notes_pattern, true, true) -- glob(pattern, ignore_case, list)
  local current_week = vim.fn.strftime(M.config.week_format)
  local todos = {}

  for _, file in ipairs(files) do
    local file_week = vim.fn.strftime(M.config.week_format, vim.fn.getftime(file))
    if file_week == current_week then
      local content = vim.fn.readfile(file)
      for i, line in ipairs(content) do
        -- Find unchecked markdown todos
        if line:match('^%s*%- %[ %] ') then
          -- Store the task, file path, and line number for later
          table.insert(todos, { text = line, file = file, lnum = i })
        end
      end
    end
  end

  -- Display the todos in a new scratch buffer
  vim.cmd('new')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.filetype = 'markdown'
  vim.api.nvim_buf_set_name(0, 'This Week’s TODOs')

  local buffer_lines = { '# This Week’s TODOs', '' }
  vim.b.todos_metadata = {}
  if #todos == 0 then
    table.insert(buffer_lines, 'No pending tasks for this week. Great job!')
  else
    for _, todo in ipairs(todos) do
      -- We add the file path as a comment to make it easy to find
      local display_line = todo.text .. ' -- ' .. vim.fn.fnamemodify(todo.file, ':t')
      table.insert(buffer_lines, display_line)
      table.insert(vim.b.todos_metadata, todo)
    end
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, buffer_lines)

  -- At the end of show_this_week_todos
  vim.api.nvim_buf_set_keymap(
    0, -- 0 for current buffer
    'n', -- Normal mode
    '<leader>d', -- The key sequence
    '<Cmd>lua require("markdown-notes").assign_date_to_task()<CR>',
    { noremap = true, silent = true, desc = "Assign date to task" }
  )
end

-- In lua/markdown-notes/init.lua
function M.assign_date_to_task()
  local cursor_lnum = vim.api.nvim_win_get_cursor(0)[1]
  -- The metadata table index corresponds to the line number in the buffer
  -- (adjust for header lines)
  local task_meta = vim.b.todos_metadata[cursor_lnum - 2] -- -2 for header and blank line

  if not task_meta then return end

  -- Prompt user for a date
  local date_str = vim.fn.input('Assign date (YYYY-MM-DD): ')
  if date_str == '' then return end

  -- Modify the original file
  local original_line = task_meta.text
  local new_line = original_line .. ' @[' .. date_str .. ']'

  local file_content = vim.fn.readfile(task_meta.file)
  file_content[task_meta.lnum] = new_line
  vim.fn.writefile(file_content, task_meta.file)

  vim.notify('Assigned date to task in ' .. vim.fn.fnamemodify(task_meta.file, ':t'))
  -- You could also update the line in the TODO buffer to reflect the change
end

return M
