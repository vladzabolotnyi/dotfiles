return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    -- Gruvbox dark colors
    local colors = {
      bg = "#282828",
      fg = "#ebdbb2",
      yellow = "#fabd2f",
      cyan = "#8ec07c",
      darkblue = "#458588",
      green = "#b8bb26",
      orange = "#fe8019",
      violet = "#d3869b",
      magenta = "#b16286",
      blue = "#83a598",
      red = "#fb4934",
      inactive_bg = "#3c3836",
    }

    local gruvbox_theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.green, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.violet, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      command = {
        a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      inactive = {
        a = { fg = colors.fg, bg = colors.inactive_bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.inactive_bg },
        c = { fg = colors.fg, bg = colors.inactive_bg },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = gruvbox_theme,
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = colors.orange },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
