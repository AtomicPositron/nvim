return {
	"Wansmer/treesj",
	keys = { "<space>m", "<space>j", "<space>s" },
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
	config = function()
		-- For default preset
		vim.keymap.set("n", "<leader>m", require("treesj").toggle)
		-- For extending default preset with `recursive = true`
		vim.keymap.set("n", "<leader>M", function()
			require("treesj").toggle({ split = { recursive = true } })
		end)
		require("treesj").setup({})
	end,
}
