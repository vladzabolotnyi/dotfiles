return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    require("ufo").setup({
      provider_selector = function(_, _, _)
        return { "lsp", "indent" }
      end,
    })

    -- Keymaps for folding
    vim.api.nvim_set_keymap("n", "zR", ':lua require("ufo").openAllFolds()<CR>', { desc = "Open All Folds" })
    vim.api.nvim_set_keymap("n", "zM", ':lua require("ufo").closeAllFolds()<CR>', { desc = "Close All Folds" })
    vim.keymap.set("n", "zK", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.bug.hover()
      end
    end, { desc = "Peek Fold" })
  end,
}
