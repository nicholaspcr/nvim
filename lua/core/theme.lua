-- Follow the terminal theme managed by the `theme` script (.local/bin/theme),
-- which writes "dark" or "light" to $XDG_STATE_HOME/theme. Gruvbox keys off
-- 'background', and Neovim reloads the active colorscheme when it changes.
local state_dir = vim.env.XDG_STATE_HOME or (vim.env.HOME .. '/.local/state')

local function read_mode()
  local f = io.open(state_dir .. '/theme')
  if not f then
    return 'dark'
  end
  local mode = f:read('*l')
  f:close()
  return mode == 'light' and 'light' or 'dark'
end

vim.o.background = read_mode()

-- Watch the directory rather than the file so the watch survives the file
-- being replaced instead of rewritten in place.
local watcher = assert(vim.uv.new_fs_event())
watcher:start(
  state_dir,
  {},
  vim.schedule_wrap(function(_, filename)
    if filename == 'theme' then
      local mode = read_mode()
      if vim.o.background ~= mode then
        vim.o.background = mode
      end
    end
  end)
)
