local keymap = {}

keymap.cmd_func = function(command) 
  return function() vim.cmd(command) end
end

keymap.cmd = function(str)
  return '<cmd>' .. str .. '<CR>'
end

keymap.map = function(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

keymap.lsp_map = function(lhs, rhs, bufnr)
	vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr })
end

keymap.dap_map = function(mode, lhs, rhs)
	keymap.map(mode, lhs, rhs)
end

return keymap
