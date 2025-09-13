return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 0.95,
      width = 0.85, -- 85% of screen width
      height = 1, -- Auto-height
      options = {
        ruler = false,
        showcmd = false,
        laststatus = 0, -- Hide statusline
        number = true, -- Keep line numbers
        relativenumber = true, -- Keep relative line numbers
        signcolumn = "no", -- Hide sign column
        foldcolumn = "0", -- Hide fold column
      },
    },
    plugins = {
      enabled = true, -- Enables plugin integration
      gitsigns = { enabled = false }, -- Hide git signs
      tmux = { enabled = false }, -- Set to true if you use tmux and configure tmux.conf
      kitty = {
        enabled = true,
        font = "+2", -- Increase font size by 2
      },
      twilight = { enabled = true }, -- Integrate with twilight.nvim
      -- lsp = { enabled = false }, -- Example: Optionally disable LSP diagnostics
    },
  },
}
