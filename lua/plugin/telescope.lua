return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"andrew-george/telescope-themes",
      {
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},

		},
		config = function()

      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local live_grep_shortcuts = require("telescope-live-grep-args.shortcuts")
      local find_files = function()
        builtin.find_files({
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
        })
      end
      local default_grep_files = function()
          local input = vim.fn.input("[Global Search]: ")
          local trimmed_input = vim.fn.trim(input)

          -- Check the length of the input

          local live_grep_args = telescope.extensions.live_grep_args
          -- If the input is empty open the search prompt

          if trimmed_input == "" then
            live_grep_args.live_grep_args()
            return
          end

          builtin.grep_string({ search = trimmed_input })
      end
      telescope.setup({
        defaults =  {
          winblend = 40,
        }
      })

      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>fg', default_grep_files, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>ff', find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fw', live_grep_shortcuts.grep_word_under_cursor, {desc = "Fuzzy find word under cursor in cwd"})
			vim.keymap.set("n", "<leader>th", ":Telescope themes<CR>",
				{ noremap = true, silent = true, desc = "Theme Switcher" }
			)
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
   end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					layout_config = {
						vertical = { width = 1 },
					},
				},
				pickers = {
					find_files = {
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					file_browser = {
						hijack_netrw = true,
					},
				},
			})
			telescope.load_extension("ui-select")
			telescope.load_extension("file_browser")
	    telescope.load_extension('lazygit')
      telescope.load_extension("themes")

      vim.api.nvim_set_hl(0, "TelescopeNormal", {bg = "none"})
		end,
	},
}
