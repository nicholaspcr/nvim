-- Headless sanity check for the config. Run locally with:
--   nvim --headless -c 'luafile scripts/smoke.lua' -c 'qa'
-- (not `-l`, which skips lazy.nvim's setup and so registers no plugins)
-- Every module under lua/ must load, every plugin spec must return a table,
-- and a few invariants that have regressed before are asserted directly.
local failures = {}

local function check(label, fn)
  local ok, err = pcall(fn)
  if not ok then
    failures[#failures + 1] = label .. ': ' .. tostring(err)
  end
end

---@param dir string absolute path
---@param prefix string module prefix, e.g. 'core.'
---@return string[]
local function modules(dir, prefix)
  local names = {}
  for entry, kind in vim.fs.dir(dir) do
    if kind == 'file' and entry:match('%.lua$') then
      names[#names + 1] = prefix .. (entry:gsub('%.lua$', ''))
    end
  end
  table.sort(names)
  return names
end

local root = vim.fn.stdpath('config')

for _, name in ipairs(modules(root .. '/lua/core', 'core.')) do
  check(name, function()
    require(name)
  end)
end

for _, group in ipairs({ { 'lsp', 'lsp.' }, { 'plugins', 'plugins.' } }) do
  for _, name in ipairs(modules(root .. '/lua/' .. group[1], group[2])) do
    check(name, function()
      assert(type(require(name)) == 'table', 'must return a table')
    end)
  end
end

check('spellfile directory', function()
  local dir = vim.fn.fnamemodify(vim.o.spellfile, ':h')
  assert(vim.fn.isdirectory(dir) == 1, dir .. ' does not exist, zg would fail with E484')
end)

check('viewdir', function()
  assert(vim.fn.isdirectory(vim.o.viewdir) == 1, vim.o.viewdir .. ' does not exist')
end)

check('neovim version', function()
  -- README states a 0.12+ floor; CI tracks 'stable', so assert it rather than
  -- pinning the action to a version that would stop moving.
  assert(vim.fn.has('nvim-0.12') == 1, 'this config requires Neovim 0.12+')
end)

check('plugins registered', function()
  assert(#require('lazy').plugins() > 0, 'lazy.nvim registered no plugins')
end)

if #failures > 0 then
  io.stderr:write('smoke check FAILED\n')
  for _, failure in ipairs(failures) do
    io.stderr:write('  ' .. failure .. '\n')
  end
  vim.cmd('cquit 1')
end

io.stdout:write('smoke check passed\n')
