return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
        signs = {
          text = {
            Error = " ",
            Warn = " ",
            Hint = "󰠠 ",
            Info = " ",
          },
          numhl = {
            Error = "DiagnosticSignError",
            Warn = "DiagnosticSignWarn",
            Hint = "DiagnosticSignHint",
            Info = "DiagnosticSignInfo",
          },
          linehl = {
            Error = "DiagnosticLineError",
            Warn = "DiagnosticLineWarn",
            Hint = "DiagnosticLineHint",
            Info = "DiagnosticLineInfo",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }), -- Clear ensures it's only set once
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          local keymap = vim.keymap

          opts.desc = "Show LSP references"
          keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
          opts.desc = "Show LSP definitions"
          keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
          opts.desc = "Show LSP implementations"
          keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
          opts.desc = "Show LSP type definitions"
          keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
          opts.desc = "Show buffer diagnostics"
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show diagnostics for file
          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
          opts.desc = "Go to next diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
          opts.desc = "Show documentation for what is under cursor"
          keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end,
      })

      -- Mason LSP config setup (should be called after nvim-lspconfig is available)
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "svelte",
          "emmet_ls",
          "ts_ls",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "prismals",
          "pyright",
          "tailwindcss",
          "htmx",
          "bashls",
          "templ",
        },
        automatic_setup = true,
        -- automatic_enable = true,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
          end,
          ["svelte"] = function()
            require("lspconfig")["svelte"].setup({
              on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePost", {
                  buffer = bufnr,
                  pattern = { "*.js", "*.ts" },
                  callback = function(ctx)
                    client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                  end,
                })
              end,
            })
          end,
          ["emmet_ls"] = function()
            require("lspconfig")["emmet_ls"].setup({
              filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
            })
          end,
          ["lua_ls"] = function()
            require("lspconfig")["lua_ls"].setup({
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                  completion = {
                    callSnippet = "Replace",
                  },
                  workspace = {
                    checkThirdParty = false,
                  },
                },
              },
            })
          end,
          ["gopls"] = function()
            require("lspconfig")["gopls"].setup({
              cmd = { "gopls", "serve" },
              filetypes = { "go", "go.mod", "go.work" },
              root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
              settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                    shadow = true,
                  },
                  staticcheck = true,
                },
              },
            })
          end,
          ["templ"] = function()
            require("lspconfig")["templ"].setup({
              filetypes = { "templ" },
              root_dir = require("lspconfig.util").root_pattern("go.mod", "go.work", ".git"),
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
          end,
          ["htmx"] = function()
            require("lspconfig")["htmx"].setup({
              filetypes = { "html", "templ" },
            })
          end,
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        max_concurrent_installers = 5,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",
          "goimports",
          "stylua",
          "isort",
          "black",
          "pylint",
          "eslint_d",
          "golangci-lint",
          "gomodifytags",
          "impl",
          "ruff",
          "debugpy",
          "delve",
          "htmlhint",
          "sqlfluff",
          "shellcheck",
          "shfmt",
          "templ",
        },
      })
    end,
  },
}
