return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    -- { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "svelte",
        "graphql",
        "emmet_ls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,
        ["svelte"] = function()
          require("lspconfig")["svelte"].setup({
            -- capabilities = capabilities, -- Handled by default handler
            on_attach = function(client, bufnr)
              -- Your existing BufWritePost autocmd
              vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.js", "*.ts" },
                callback = function(ctx)
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                end,
              })
            end,
          })
        end,

        ["graphql"] = function()
          require("lspconfig")["graphql"].setup({
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
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
            filetypes = { "go", "go.mod", "go.work" }, -- Added go.work
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
      },
    })
  end,
}
