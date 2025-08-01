return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
            -- Don't need those classes for now but later I'd like to find alternative of ac/ic
            -- ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
            ["ac"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["ic"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

            -- Language-specific keymaps
            ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
            ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
            ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
            ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
            ["<leader>n:"] = "@property.outer", -- swap object property with next
            ["<leader>nf"] = "@function.outer", -- swap function with next
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
            ["<leader>p:"] = "@property.outer", -- swap object property with prev
            ["<leader>pf"] = "@function.outer", -- swap function with previous
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            -- ["]f"] = { query = "@call.outer", desc = "Next function call start" },
            ["[f"] = { query = "@function.outer", desc = "Next method/function def start" },
            -- ["[c"] = { query = "@class.outer", desc = "Next class start" },
            ["[c"] = { query = "@conditional.outer", desc = "Next conditional start" },
            ["[l"] = { query = "@loop.outer", desc = "Next loop start" },

            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            -- ["]F"] = { query = "@call.outer", desc = "Next function call end" },
            ["[F"] = { query = "@function.outer", desc = "Next method/function def end" },
            -- ["[C"] = { query = "@class.outer", desc = "Next class end" },
            ["[C"] = { query = "@conditional.outer", desc = "Next conditional end" },
            ["[L"] = { query = "@loop.outer", desc = "Next loop end" },
          },
          goto_previous_start = {
            -- ["]f"] = { query = "@call.outer", desc = "Prev function call start" },
            ["]f"] = { query = "@function.outer", desc = "Prev method/function def start" },
            -- ["]c"] = { query = "@class.outer", desc = "Prev class start" },
            ["]c"] = { query = "@conditional.outer", desc = "Prev conditional start" },
            ["]l"] = { query = "@loop.outer", desc = "Prev loop start" },
          },
          goto_previous_end = {
            -- ["]F"] = { query = "@call.outer", desc = "Prev function call end" },
            ["]F"] = { query = "@function.outer", desc = "Prev method/function def end" },
            -- ["]C"] = { query = "@class.outer", desc = "Prev class end" },
            ["]C"] = { query = "@conditional.outer", desc = "Prev conditional end" },
            ["]L"] = { query = "@loop.outer", desc = "Prev loop end" },
          },
        },
      },
    })

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- vim way: ; goes to the direction you were moving.
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
  end,
}
