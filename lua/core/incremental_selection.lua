-- Treesitter incremental selection (<C-space> to expand, <BS> to shrink).
-- Replacement for the module dropped by the nvim-treesitter main rewrite;
-- uses only built-in vim.treesitter APIs.
local M = {}

-- Per-buffer stack of selected nodes
local stacks = {}

local function same_range(a, b)
  local ar1, ac1, ar2, ac2 = a:range()
  local br1, bc1, br2, bc2 = b:range()
  return ar1 == br1 and ac1 == bc1 and ar2 == br2 and ac2 == bc2
end

local function select_node(node)
  local srow, scol, erow, ecol = node:range()
  -- Node end is exclusive; convert to inclusive visual marks
  if ecol == 0 then
    erow = erow - 1
    local line = vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or ''
    ecol = math.max(#line, 1)
  end
  vim.api.nvim_buf_set_mark(0, '<', srow + 1, scol, {})
  vim.api.nvim_buf_set_mark(0, '>', erow + 1, ecol - 1, {})
  vim.cmd('normal! gv')
end

function M.start()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or node == nil then
    return
  end
  stacks[vim.api.nvim_get_current_buf()] = { node }
  select_node(node)
end

function M.increment()
  local buf = vim.api.nvim_get_current_buf()
  local stack = stacks[buf]
  if stack == nil or #stack == 0 then
    return M.start()
  end
  local current = stack[#stack]
  local parent = current:parent()
  -- Skip ancestors that span the same range, so every step grows
  while parent ~= nil and same_range(parent, current) do
    parent = parent:parent()
  end
  if parent == nil then
    select_node(current)
    return
  end
  stacks[buf] = vim.list_extend({ unpack(stack) }, { parent })
  select_node(parent)
end

function M.decrement()
  local buf = vim.api.nvim_get_current_buf()
  local stack = stacks[buf]
  if stack == nil or #stack <= 1 then
    if stack and stack[1] then select_node(stack[1]) end
    return
  end
  local shrunk = { unpack(stack, 1, #stack - 1) }
  stacks[buf] = shrunk
  select_node(shrunk[#shrunk])
end

return M
