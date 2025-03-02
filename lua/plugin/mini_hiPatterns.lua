return {
  'echasnovski/mini.hipatterns',
  event = "BufReadPre",
  opts = {},
  config = function ()
    require('mini.hipatterns').setup()
  end
}
