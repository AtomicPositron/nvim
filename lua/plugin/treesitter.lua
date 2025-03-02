return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
  event = {"BufReadPre", "BufNewFile"},
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
		auto_install = true,
			sync_install = false,
			highlight = {
        enable = true,
        additional_vim_regex_highlight = false 
      },
			indent = { enable = true },
		})
	end,
}
