return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
