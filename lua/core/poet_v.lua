vim.g.poetv_executables = { "poetry" }
vim.g.poetv_auto_activate = 0
vim.g.poetv_set_environment = 1
vim.g.poetv_statusline_symbol = "🐍"

-- Setup Autocommands

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*/.venv/*", "*.py" },
    callback = function()
        -- check if poetv is activated

        if vim.g.poetv_name ~= nil then
            return
        else
            vim.cmd([[ PoetvActivate ]])
            vim.cmd([[ LspRestart ]])
        end
    end,
})
