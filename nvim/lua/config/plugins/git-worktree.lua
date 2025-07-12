return {
  "ThePrimeagen/git-worktree.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  -- for some reason plugin hasn't been running when I place it in config
  init = function()
    if pcall(require, "telescope") then
      require("telescope").load_extension("git_worktree")
    end
  end,
  keys = {
    {
      "<leader>wl",
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
      desc = "Git: List/Switch Worktrees (Telescope)",
    },
    {
      "<leader>wn", -- g-n for git-new-worktree
      function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
      desc = "Git: Create New Worktree (Telescope)",
    },
    {
      "<leader>wm",
      function()
        -- This example is hardcoded. You'd typically use prompts or Telescope.
        -- For a practical keymap, you'd likely use the Telescope version above.
        local path = vim.fn.input("Worktree Path (relative or absolute): ")
        local branch = vim.fn.input("New Branch Name: ")
        local upstream = vim.fn.input("Upstream (e.g., origin): ")
        if path ~= "" and branch ~= "" and upstream ~= "" then
          require("git-worktree").create_worktree(path, branch, upstream)
        else
          print("Creation cancelled or invalid input.")
        end
      end,
      desc = "Git: Create Worktree (manual)",
    },
    -- {
    --   "<leader>gd",
    --   function()
    --     -- Again, typically use Telescope for selection.
    --     local path = vim.fn.input("Worktree Path to delete: ")
    --     if path ~= "" then
    --       require("git-worktree").delete_worktree(path)
    --     else
    --       print("Deletion cancelled or invalid input.")
    --     end
    --   end,
    --   desc = "Git: Delete Worktree (manual)",
    -- },
  },
}
