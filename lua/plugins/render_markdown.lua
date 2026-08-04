-- In-buffer markdown rendering (headings, tables, checkboxes, code blocks).
-- <Leader>tm swaps the current buffer between the rendered view and raw source.

-- Gruvbox defines no per-level heading groups, so the plugin's fallbacks win and
-- headings borrow the diff highlights: H1 lands on DiffText, a full-width band of
-- bright yellow. Build a per-level ramp instead -- a gruvbox accent for the text,
-- and that same accent mixed into the background at low ratio for the band.
local HEADING_ACCENTS = { 'red', 'orange', 'yellow', 'green', 'aqua', 'blue' }
local BACKGROUND_MIX = 0.15

---@param hex string '#rrggbb'
---@param offset integer index of the channel's first digit
---@return integer
local function channel(hex, offset)
  return tonumber(hex:sub(offset, offset + 1), 16)
end

---@param accent string '#rrggbb'
---@param base string '#rrggbb'
---@param ratio number share of accent in the result
---@return string '#rrggbb'
local function mix(accent, base, ratio)
  local result = '#'
  for offset = 2, 6, 2 do
    local value = channel(accent, offset) * ratio + channel(base, offset) * (1 - ratio)
    result = result .. ('%02x'):format(math.floor(value + 0.5))
  end
  return result
end

-- Reloading a colorscheme clears every highlight, so this runs on ColorScheme
-- too -- lua/core/theme.lua flips 'background' when the terminal theme changes.
local function heading_highlights()
  local palette = require('gruvbox').palette
  local dark = vim.o.background == 'dark'
  local base = dark and palette.dark0 or palette.light0
  local variant = dark and 'bright_' or 'faded_'

  for level, name in ipairs(HEADING_ACCENTS) do
    local accent = palette[variant .. name]
    local group = 'RenderMarkdownH' .. level
    vim.api.nvim_set_hl(0, group, { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, group .. 'Bg', { bg = mix(accent, base, BACKGROUND_MIX) })
  end
end

local function config(_, opts)
  require('render-markdown').setup(opts)
  heading_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('RenderMarkdownHeadingColors', {}),
    callback = heading_highlights,
  })
end

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  cmd = 'RenderMarkdown',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<Leader>tm', '<cmd>RenderMarkdown buf_toggle<CR>', desc = 'Toggle markdown render', ft = 'markdown' },
  },
  config = config,
  opts = {
    -- Match after/ftplugin/markdown.lua so toggling the render off restores
    -- the conceal state the buffer started with (the plugin would otherwise
    -- fall back to the global values).
    win_options = {
      conceallevel = { default = 2, rendered = 3 },
      concealcursor = { default = 'nc', rendered = '' },
    },
  },
}
