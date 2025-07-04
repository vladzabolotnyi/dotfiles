return {
  -- 1. nvim-lspconfig: This is the core LSP client.
  -- It should be loaded when an LSP-related action is likely to happen.
  {
    "neovim/nvim-lspconfig",
    -- Use "BufReadPre" and "BufNewFile" to load lspconfig only when opening or creating a file.
    -- This ensures it's not loaded for every Neovim startup.
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- These are dependencies of nvim-lspconfig and should be loaded with it.
      "hrsh7th/cmp-nvim-lsp", -- For LSP completion source
      { "antosha417/nvim-lsp-file-operations", config = true }, -- Load and configure this immediately
      -- Mason and mason-lspconfig are also dependencies. We will define their configurations
      -- within *this* main LSP plugin definition.
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- LSP diagnostic configuration (can be placed here as it's directly related to LSP)
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
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

      -- LSP Keymaps and autocmds (should be defined once lspconfig is loaded)
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
          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
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
        },
        automatic_setup = true,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              -- Add a generic on_attach if you have one for all servers
              -- on_attach = on_attach_function, -- If you define a global on_attach
            })
          end,
          ["svelte"] = function()
            require("lspconfig")["svelte"].setup({
              on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePost", {
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
              -- Specific settings for templ LSP if needed
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

  -- 2. Mason.nvim: The package manager for LSP servers and other tools.
  -- It's a dependency of mason-lspconfig.nvim, so it will be loaded when
  -- mason-lspconfig.nvim is loaded (which is on BufReadPre/BufNewFile).
  {
    "williamboman/mason.nvim",
    -- 'cmd' event means it only loads when these commands are run.
    -- This is good for mason itself, as you typically run these manually.
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    build = ":MasonUpdate", -- Run this build command after install/update
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

  -- 3. Mason-Tool-Installer: For installing formatters, linters, etc.
  -- This should also be deferred. "VeryLazy" is a good event for this,
  -- as it can happen after the initial startup.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- 'VeryLazy' means it will load after everything else,
    -- which is fine for installing tools in the background.
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
        },
      })
    end,
  },
}
