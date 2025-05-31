return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configure DAP UI with best practices
      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "→",
        },
        mappings = {
          -- Use a table to apply multiple mappings
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
            size = 55, -- Wider sidebar for better readability
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 0.35, -- Taller console area
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded", -- Cleaner looking borders
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = 60, -- Limits long type signatures
          max_value_lines = 100, -- More content for large values
        },
      })

      -- Optional: Configure DAP virtual text (shows variable values inline)
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol", -- 'eol' | 'inline'
        all_frames = false,
      })

      -- Configure DAP-Go with best practices
      require("dap-go").setup({
        delve = {
          path = "dlv",
          args = {},
          build_flags = "",
          initialize_timeout_sec = 20,
          port = "${port}",
        },
      })

      -- Recommended: Close dapui automatically when debugging ends
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Setup nice looking icons for breakpoints and the current position
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "▶️", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
      )

      -- Keymaps with helpful descriptions
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "DAP: Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "DAP: Set Log Point" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
      vim.keymap.set("n", "<leader>dr", dapui.open, { desc = "DAP: Open UI" })
      vim.keymap.set("n", "<leader>dR", function()
        dapui.open({ reset = true })
      end, { desc = "DAP: Reset UI" })
      vim.keymap.set("n", "<leader>dx", dapui.close, { desc = "DAP: Close UI" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "DAP: Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP: Step Out" })
      vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "DAP: Terminate" })
      vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "DAP: Pause" })
      vim.keymap.set("n", "<leader>dw", function()
        require("dapui").float_element("watches", { enter = true })
      end, { desc = "DAP: Add Watch" })
      vim.keymap.set("n", "<leader>dS", function()
        require("dapui").float_element("scopes", { enter = true })
      end, { desc = "DAP: View Scopes" })
      vim.keymap.set("n", "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "DAP: Hover Variable" })

      -- Optional: Telescope integration (if you have Telescope installed)
      -- Uncomment if you want to use Telescope integration
      -- require('telescope').load_extension('dap')
      -- vim.keymap.set("n", "<leader>df", ":Telescope dap frames<CR>", { desc = "DAP: List Frames" })
      -- vim.keymap.set("n", "<leader>dC", ":Telescope dap commands<CR>", { desc = "DAP: List Commands" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require("dap")

      -- Use Mason's debugpy if available
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"
      require("dap-python").setup(path)

      -- Add Python test configurations
      require("dap-python").test_runner = "pytest"

      -- Python-specific keymaps
      vim.keymap.set("n", "<leader>dpm", function()
        require("dap-python").test_method()
      end, { desc = "DAP Python: Test Method" })
      vim.keymap.set("n", "<leader>dpc", function()
        require("dap-python").test_class()
      end, { desc = "DAP Python: Test Class" })
      vim.keymap.set("n", "<leader>dps", function()
        require("dap-python").debug_selection()
      end, { desc = "DAP Python: Debug Selection" })
    end,
  },
}
