return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      html = { "tidy" },
      css = { "stylelint" },
      scss = { "stylelint" },
      vue = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "ruff" },
      go = { "golangci-lint" },
    }

    lint.linters.tidy = {
      cmd = "tidy",
      args = { "-e", "-q" },
      stream = "stderr",
      ignore_exitcode = true,
    }

    lint.linters.stylelint = {
      cmd = "stylelint",
      args = { "--formatter", "json", "--stdin-filename", "%filepath" },
      stdin = true,
      stream = "stdout",
      ignore_exitcode = true,
    }

    lint.linters["golangci-lint"] = {
      cmd = "golangci-lint",
      args = { "run", "--out-format", "json" },
      stdin = true,
      stream = "stdout",
      ignore_exitcode = true,
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Add a keybinding to manually trigger linting
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    -- Optional: Add error handling for missing linters
    vim.api.nvim_create_user_command("LintInfo", function()
      local ft = vim.bo.filetype
      local linters = lint.linters_by_ft[ft] or {}
      if #linters == 0 then
        print("No linters configured for filetype: " .. ft)
      else
        for _, linter in ipairs(linters) do
          local ok = pcall(require, "lint.linters." .. linter)
          if not ok then
            print("Linter not found: " .. linter)
          else
            print("Linter available: " .. linter)
          end
        end
      end
    end, {})
  end,
}
