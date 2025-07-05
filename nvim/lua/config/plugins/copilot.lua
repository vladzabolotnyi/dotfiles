return {
  "github/copilot.vim",
  enabled = false,
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.cmd([[let g:copilot_enabled = 0]])
  end,
}
