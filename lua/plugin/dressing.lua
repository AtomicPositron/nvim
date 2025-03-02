return{
  'stevearc/dressing.nvim',
  opts = {},
  event = "VeryLazy",
  config = function()
    require("dressing").setup({
      input = {
        enabled = true
      }
    })
  end
}
