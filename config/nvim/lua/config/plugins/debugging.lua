return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "simrat39/rust-tools.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      local ok_virtual_text, _ = pcall(require, "nvim-dap-virtual-text")
      local ok_go, _ = pcall(require, "dap-go")
      local ok_telescope, _ = pcall(require, "telescope")

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb") ~= "" and vim.fn.exepath("codelldb")
            or vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Debug Rust Program",
          type = "codelldb",
          request = "launch",
          program = function()
            local cargo_toml = vim.fn.getcwd() .. "/Cargo.toml"
            if vim.fn.filereadable(cargo_toml) == 1 then
              local project_name = vim.fn.fnamemodify(cargo_toml, ":h:t")
              return vim.fn.getcwd() .. "/target/debug/" .. project_name
            end
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {}, -- Start with empty args, can be overridden
          terminal = "integrated",
          sourceLanguages = { "rust" },
        },
        -- Simple test configuration
        {
          name = "Debug Rust Tests",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Try to find test executable
            local handle = io.popen("cargo test --no-run --message-format=json 2>/dev/null")
            if handle then
              local result = handle:read("*a")
              handle:close()
              for line in result:gmatch("[^\r\n]+") do
                local ok, json = pcall(vim.json.decode, line)
                if ok and json.executable then
                  return json.executable
                end
              end
            end
            -- Fallback
            return vim.fn.input("Path to test executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          args = {},
        },
      }

      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "→",
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.45 },
              { id = "watches", size = 0.15 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks", size = 0.20 },
            },
            size = 55,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 0.35,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = 60,
          max_value_lines = 100,
        },
      })

      if ok_virtual_text then
        require("nvim-dap-virtual-text").setup({
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          virt_text_pos = "eol",
          all_frames = false,
        })
      end

      if ok_go then
        require("dap-go").setup({
          delve = {
            path = vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "/home/linuxbrew/.linuxbrew/bin/dlv",
            args = {},
            build_flags = "",
            initialize_timeout_sec = 20,
            port = "${port}",
          },
        })
      end

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "DapStoppedLine", numhl = "" })

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Set conditional breakpoint" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "Set log point" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/continue debugging" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Stop debugging" })
      vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause debugging" })

      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>de", function()
        dapui.eval(vim.fn.input("Expression: "))
      end, { desc = "Evaluate expression" })
      vim.keymap.set("v", "<leader>de", function()
        dapui.eval()
      end, { desc = "Evaluate selection" })
      vim.keymap.set("n", "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Hover variables" })
      vim.keymap.set("n", "<leader>dS", function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)
      end, { desc = "Show scopes" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function()
          vim.keymap.set("n", "<leader>drb", function()
            vim.cmd("!cargo build")
            print("Build completed. Start debugging with <leader>dc")
          end, { buffer = true, desc = "Build Rust project" })

          vim.keymap.set("n", "<leader>drt", function()
            dap.run(dap.configurations.rust[2]) -- Test configuration
          end, { buffer = true, desc = "Debug Rust tests" })
        end,
      })

      if ok_telescope then
        pcall(function()
          require("telescope").load_extension("dap")
          vim.keymap.set("n", "<leader>df", ":Telescope dap frames<CR>", { desc = "Debug frames" })
          vim.keymap.set("n", "<leader>dC", ":Telescope dap commands<CR>", { desc = "Debug commands" })
        end)
      end
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require("dap")

      -- Find debugpy
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local system_path = vim.fn.exepath("python3")

      local debugpy_path = vim.fn.filereadable(mason_path) == 1 and mason_path or system_path

      require("dap-python").setup(debugpy_path, {
        pythonPath = function()
          local venv = os.getenv("VIRTUAL_ENV")
          return venv and venv .. "/bin/python" or debugpy_path
        end,
        console = "integratedTerminal",
        justMyCode = false,
      })

      -- Python keymaps
      vim.keymap.set("n", "<leader>dpm", function()
        require("dap-python").test_method()
      end, { desc = "Debug Python method" })
      vim.keymap.set("n", "<leader>dpc", function()
        require("dap-python").test_class()
      end, { desc = "Debug Python class" })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        tools = {
          hover_actions = { auto_focus = true },
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
          },
        },
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set(
              "n",
              "<leader>ra",
              rt.hover_actions.hover_actions,
              { buffer = bufnr, desc = "Rust hover actions" }
            )
            vim.keymap.set(
              "n",
              "<leader>rr",
              rt.code_action_group.code_action_group,
              { buffer = bufnr, desc = "Rust code actions" }
            )
          end,
        },
      })
    end,
  },
}
