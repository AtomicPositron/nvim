--HACK Not working Properly 
return{
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  events =  { "BufReadPre", "BufNewFile" },
  config = function ()
    vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<cr>", {desc =  "Find Todos"})
    require("todo-comments").setup()
  end
}
