-- Treesitter configuration for syntax highlighting and navigation
-- Version: Tracking master branch for latest parsers
local function nvim_treesitter()
  local ts_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
  if not ts_ok then
    vim.notify("Failed to load nvim-treesitter", vim.log.levels.ERROR)
    return
  end

  -- Fold configuration is set in core/options.lua
  ts_configs.setup({
    ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "go",
        "javascript",
        "proto",
        "readline",
        "terraform",
        "typescript",
        "xml",
        "sql"
    },
    auto_install = true,

    highlight = {
      enable = true,
    },
    indent = { enable = true },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },

    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          ["aa"] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
          ["ia"] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
          ["la"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
          ["ra"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

          ["ap"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
          ["ip"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

          ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
          ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

          ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
          ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

          ["am"] = { query = "@call.outer", desc = "Select outer part of a function call" },
          ["im"] = { query = "@call.inner", desc = "Select inner part of a function call" },

          ["af"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
          ["if"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

          ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
        },
      },

      swap = {
        enable = true,
        swap_next = {
          ["<leader>np"] = "@parameter.inner", -- swap parameters/argument with next
          ["<leader>nf"] = "@function.outer", -- swap function with next
        },
        swap_previous = {
          ["<leader>bp"] = "@parameter.inner", -- swap parameters/argument with prev
          ["<leader>bf"] = "@function.outer", -- swap function with previous
        },
      },

      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = { query = "@call.outer", desc = "Next function call start" },
          ["]f"] = { query = "@function.outer", desc = "Next method/function def start" },
          ["]c"] = { query = "@class.outer", desc = "Next class start" },
          ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
          ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

          -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
          -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
          ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
        },
        goto_next_end = {
          ["]M"] = { query = "@call.outer", desc = "Next function call end" },
          ["]F"] = { query = "@function.outer", desc = "Next method/function def end" },
          ["]C"] = { query = "@class.outer", desc = "Next class end" },
          ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
          ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
        },
        goto_previous_start = {
          ["[m"] = { query = "@call.outer", desc = "Prev function call start" },
          ["[f"] = { query = "@function.outer", desc = "Prev method/function def start" },
          ["[c"] = { query = "@class.outer", desc = "Prev class start" },
          ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
          ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
        },
        goto_previous_end = {
          ["[M"] = { query = "@call.outer", desc = "Prev function call end" },
          ["[F"] = { query = "@function.outer", desc = "Prev method/function def end" },
          ["[C"] = { query = "@class.outer", desc = "Prev class end" },
          ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
          ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
        },
      },
    },
  })

  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

  -- vim way: ; goes to the direction you were moving.
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
end
return {
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPre", "BufNewFile" },
  build = ':TSUpdate',
  config = nvim_treesitter,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
}
