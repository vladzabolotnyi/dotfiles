return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disable_mouse = false,
    disable_keys = {
      ["<Up>"] = {},
      ["<Left>"] = {},
      ["<Right>"] = {},
      -- ["Down"] = {},
    },
  },
}
