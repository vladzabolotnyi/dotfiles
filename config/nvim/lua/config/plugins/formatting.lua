return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      -- temporaly set DEBUG level to get more info while polishing config
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        javascript = { "eslint_d", "prettier" },
        typescript = { "eslint_d", "prettier" },
        javascriptreact = { "eslint_d", "prettier" },
        typescriptreact = { "eslint_d", "prettier" },
        svelte = { "eslint_d", "prettier" },
        css = { "prettier" },
        html = { "prettier", "eslint_d" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "goimports" },
        templ = { "templ" },
        sql = { "sqlfluff" },
        sh = { "shfmt" },
      },
      format_after_save = {
        async = true,
        lsp_fallback = true,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 4000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
