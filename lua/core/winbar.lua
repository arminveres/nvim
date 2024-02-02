local reset = "%#Normal#"

-- Create an autocommand group for winbar customization
vim.api.nvim_create_augroup("WinbarCustomization", { clear = true })

-- Set active winbar on entering a window
vim.api.nvim_create_autocmd("WinEnter", {
    group = "WinbarCustomization",
    callback = function()
        local current_win = vim.api.nvim_get_current_win()
        local win_config = vim.api.nvim_win_get_config(current_win)

        if win_config.relative ~= "" then
            return
        end

        vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
})

-- Set inactive winbar on leaving a window
vim.api.nvim_create_autocmd("WinLeave", {
    group = "WinbarCustomization",
    callback = function()
        local current_win = vim.api.nvim_get_current_win()
        local win_config = vim.api.nvim_win_get_config(current_win)

        if win_config.relative ~= "" then
            return
        end

        vim.wo.winbar = reset .. string.format(" [%d] %s", vim.api.nvim_win_get_number(0), "%f")
    end,
})
