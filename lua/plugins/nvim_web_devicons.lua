local function nvim_web_devicons()
  require'nvim-web-devicons'.setup()
end

return {
  'nvim-tree/nvim-web-devicons',
  config = nvim_web_devicons,
}
