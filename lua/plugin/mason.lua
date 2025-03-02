return{
{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
  {
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls",
		"astro",
		"biome",
		"rust_analyzer",
		"emmet_ls",
		"lua_ls",
		"arduino_language_server",
		"tailwindcss",
		"svelte",
		"jedi_language_server",
		"kotlin_language_server","lua_ls", "clangd", "cssls", "html", "pyright", "volar", "vuels" },
			})
		end,
	}
}
