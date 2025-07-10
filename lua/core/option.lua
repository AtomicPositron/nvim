local opt = vim.opt
local current_home = os.getenv("HOME") or os.getenv("USERPROFILE")

vim.g.python3_host_prog = current_home .. "/.pyenv/versions/py3nvim/bin/python"

vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,"
    .. "a:blinkwait200-blinkoff400-blinkon250-Cursor/lCursor,"
    .. "sm:block-blinkwait155-blinkoff150-blinkon175"

-- Function to change cursor color
local function set_cursor_color(color)
    vim.api.nvim_set_hl(0, "Cursor", { fg = color, bg = color })
end
-- Autocommands to change cursor color based on mode
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        set_cursor_color("#ffffff") -- Red in insert mode
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        set_cursor_color("#7DF9FF") -- Blue in visual mode
    end,
})
opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = true
opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"
opt.hlsearch = true
opt.backup = false
opt.laststatus = 0
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.scrolloff = 10
opt.inccommand = "split"
opt.relativenumber = false
opt.swapfile = false
opt.smarttab = true
opt.breakindent = true
opt.backspace = { "start", "eol", "indent" }
opt.splitright = true
opt.splitkeep = "cursor"
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.path:append({ "**" })
opt.formatoptions:append({ "r" })
vim.cmd("let g:netrw_liststyle = 3")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, 'Comment', { italic = true })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.cmd("highlight Comment cterm=italic ctermfg=8")
vim.g.have_nerd_font = true

vim.g.neovide_fullscreen = true
vim.g.neovide_opacity = 0.9
vim.g.neovide_cursor_smooth_blink = true
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_scale_factor = 0.7
vim.g.neovide_cursor_trail_size = 0.9
vim.g.neovide_cursor_vfx_mode = "sonicboom"
