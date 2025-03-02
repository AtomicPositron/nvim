vim.g.mapleader = " "
local keymaps = vim.keymap

local opts = { noremap = true, silent = true }

keymaps.set("n", "<Leader>w", ":update<Return>",{desc = "Update"}, opts)
keymaps.set("n", "<Leader>wa", ":wa<Return>",{desc = "Save current buffer"}, opts)
keymaps.set("n", "<Leader>q", ":quit<Return>",{desc = "Quit current buffer"}, opts)
keymaps.set("n", "<Leader>qa", ":qa<Return>",{desc =  "Quit and save Current buffer"}, opts)
keymaps.set("n", "<Leader>sr", ":source %<Return>",{desc = "Update"}, opts)

keymaps.set("n", "<Leader>sv", ":split<Return>",{desc = "Split Horizontally"}, opts)
keymaps.set("n", "<Leader>sb", ":vsplit<Return>",{desc = "Split Vertically"}, opts)
keymaps.set("n", "<Leader>x", ":close<Return>", {desc = "Close"}, opts)

keymaps.set("n", "<Leader>to", "<cmd>tabnew<CR>")
keymaps.set("n", "<Leader>tx", "<cmd>tabclose<CR>")
keymaps.set("n", "<Leader>tk", "<cmd>tabn<CR>")
keymaps.set("n", "<Leader>tj", "<cmd>tabp<CR>")
keymaps.set("n", "<Leader>tb", "<cmd>tabnew %<CR>")

