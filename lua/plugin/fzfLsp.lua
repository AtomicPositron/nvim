return {
  'ojroques/nvim-lspfuzzy',
  dependencies = {
    {'junegunn/fzf'},
    {'junegunn/fzf.vim'},  -- to enable preview (optional)
  },
  
  event = {"BufReadPre", "BufNewFile"},
  config =  function()
    require('lspfuzzy').setup {}
  end

}
