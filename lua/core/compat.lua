-- Compat shim for nvim-treesitter (master) on Neovim 0.12:
-- match[capture_id] is now TSNode[] instead of TSNode, so directives like
-- `set-lang-from-info-string!` pass a list to get_node_text, which then errors
-- with "attempt to call method 'range' (a nil value)". Unwrap to first node.
-- Remove once the config migrates to the nvim-treesitter `main` rewrite.
local orig_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
  if type(node) == 'table' and node.range == nil then
    node = node[1]
    if node == nil then return '' end
  end
  return orig_get_node_text(node, source, opts)
end
