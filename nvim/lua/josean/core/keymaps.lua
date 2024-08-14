-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Gitsigns
keymap.set("n", "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", { desc = "Stage Hunk" })
keymap.set("n", "<leader>gu", "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>", { desc = "Undo Stage Hunk" })
keymap.set("n", "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", { desc = "Reset Hunk" })
keymap.set("n", "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", { desc = "Preview Hunk" })
keymap.set("n", "<leader>gb", "<cmd>lua require('gitsigns').blame_line()<cr>", { desc = "Blame Line" })
keymap.set("n", "<leader>gf", "<cmd>lua require('gitsigns').diffthis('~1')<cr>", { desc = "Diff This" })
keymap.set("n", "<leader>gn", "<cmd>lua require('gitsigns').next_hunk()<cr>", { desc = "Next Hunk" })
keymap.set("n", "<leader>gU", "<cmd>lua require('gitsigns').reset_buffer()<cr>", { desc = "Unstage All" })
keymap.set("n", "<leader>gS", "<cmd>lua require('gitsigns').stage_buffer()<cr>", { desc = "Stage All Changes" })
