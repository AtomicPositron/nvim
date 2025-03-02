return {
	"kosayoda/nvim-lightbulb",
	event = { "BufReadPre" },
	config = function()
		require("nvim-lightbulb").setup({
			autocmd = { enabled = true },
		})
	end,
}
