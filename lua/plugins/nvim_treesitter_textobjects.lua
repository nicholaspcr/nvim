-- Treesitter textobjects (main rewrite): select, swap, move, repeatable moves.
local function textobjects()
  require('nvim-treesitter-textobjects').setup({
    select = {
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
    },
    move = {
      -- Whether to set jumps in the jumplist
      set_jumps = true,
    },
  })

  local function select_obj(query, group)
    return function()
      require('nvim-treesitter-textobjects.select').select_textobject(query, group or 'textobjects')
    end
  end

  -- Select: note parameters use a,/i, so the builtin paragraph objects
  -- (ap/ip) keep working.
  local selects = {
    { 'aa', '@assignment.outer', 'Select outer assignment' },
    { 'ia', '@assignment.inner', 'Select inner assignment' },
    { 'la', '@assignment.lhs', 'Select left side of assignment' },
    { 'ra', '@assignment.rhs', 'Select right side of assignment' },
    { 'a,', '@parameter.outer', 'Select outer parameter/argument' },
    { 'i,', '@parameter.inner', 'Select inner parameter/argument' },
    { 'ai', '@conditional.outer', 'Select outer conditional' },
    { 'ii', '@conditional.inner', 'Select inner conditional' },
    { 'al', '@loop.outer', 'Select outer loop' },
    { 'il', '@loop.inner', 'Select inner loop' },
    { 'am', '@call.outer', 'Select outer function call' },
    { 'im', '@call.inner', 'Select inner function call' },
    { 'af', '@function.outer', 'Select outer function definition' },
    { 'if', '@function.inner', 'Select inner function definition' },
    { 'ac', '@class.outer', 'Select outer class' },
    { 'ic', '@class.inner', 'Select inner class' },
  }
  for _, s in ipairs(selects) do
    vim.keymap.set({ 'x', 'o' }, s[1], select_obj(s[2]), { desc = s[3] })
  end

  -- Swap: <leader>n = swap with next, <leader>N = swap with previous
  -- (mirrors n/N search direction; the old <leader>bp/<leader>bf prefix
  -- delayed <leader>b by timeoutlen).
  local swap = function(fn, query)
    return function() require('nvim-treesitter-textobjects.swap')[fn](query) end
  end
  vim.keymap.set('n', '<leader>np', swap('swap_next', '@parameter.inner'), { desc = 'Swap with next parameter' })
  vim.keymap.set('n', '<leader>nf', swap('swap_next', '@function.outer'), { desc = 'Swap with next function' })
  vim.keymap.set('n', '<leader>Np', swap('swap_previous', '@parameter.inner'), { desc = 'Swap with previous parameter' })
  vim.keymap.set('n', '<leader>Nf', swap('swap_previous', '@function.outer'), { desc = 'Swap with previous function' })

  -- Move
  local function move(fn, query, group)
    return function()
      require('nvim-treesitter-textobjects.move')[fn](query, group or 'textobjects')
    end
  end
  local moves = {
    goto_next_start = {
      { ']m', '@call.outer', 'Next function call start' },
      { ']f', '@function.outer', 'Next function def start' },
      { ']c', '@class.outer', 'Next class start' },
      { ']i', '@conditional.outer', 'Next conditional start' },
      { ']l', '@loop.outer', 'Next loop start' },
      { ']s', '@local.scope', 'Next scope', 'locals' },
      { ']z', '@fold', 'Next fold', 'folds' },
    },
    goto_next_end = {
      { ']M', '@call.outer', 'Next function call end' },
      { ']F', '@function.outer', 'Next function def end' },
      { ']C', '@class.outer', 'Next class end' },
      { ']I', '@conditional.outer', 'Next conditional end' },
      { ']L', '@loop.outer', 'Next loop end' },
    },
    goto_previous_start = {
      { '[m', '@call.outer', 'Prev function call start' },
      { '[f', '@function.outer', 'Prev function def start' },
      { '[c', '@class.outer', 'Prev class start' },
      { '[i', '@conditional.outer', 'Prev conditional start' },
      { '[l', '@loop.outer', 'Prev loop start' },
    },
    goto_previous_end = {
      { '[M', '@call.outer', 'Prev function call end' },
      { '[F', '@function.outer', 'Prev function def end' },
      { '[C', '@class.outer', 'Prev class end' },
      { '[I', '@conditional.outer', 'Prev conditional end' },
      { '[L', '@loop.outer', 'Prev loop end' },
    },
  }
  for fn, maps in pairs(moves) do
    for _, m in ipairs(maps) do
      vim.keymap.set({ 'n', 'x', 'o' }, m[1], move(fn, m[2], m[4]), { desc = m[3] })
    end
  end

  -- Repeatable moves: ; goes the direction you were moving, , the opposite.
  -- f/F/t/T stay repeatable with ;/, as well.
  local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
  vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
  vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)
  vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
  vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
  vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
  vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
end

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = textobjects,
}
