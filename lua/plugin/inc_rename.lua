return {
	"smjonas/inc-rename.nvim",
	config = function()
		require("inc_rename").setup()
		require("noice").setup({
			presets = { inc_rename = true },
		})
		vim.keymap.set("n", "<leader>rn", ":IncRename ")
	end,
}
