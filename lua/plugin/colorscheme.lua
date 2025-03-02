return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        color_overrides = {
          mocha = {
            base = "#171717",
            mantle = "#242424",
            crust = "#474747",
          },
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
      })
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup({
        on_colors = function(colors)
         -- colors.bg = "#0b0c14"
          colors.error = "#ff0000"
        end,
        on_highlights = function(hl, c)
          hl.TelescopeNormal = {
            bg = c.bg_dark,
            fg = c.fg_dark,
          }
        end,
        lualine_bold = false,
      })
    end,
  },
  { "rose-pine/neovim", name = "rose-pine" }
}
