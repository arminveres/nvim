local reset = "%#Normal#"

-- Create an autocommand group for winbar customization
local group = vim.api.nvim_create_augroup("WinbarCustomization", { clear = true })

local function is_float_win(win_id)
    local win_config = vim.api.nvim_win_get_config(win_id)
    if win_config.relative ~= "" then return true end
    return false
end

local function inactive_winbar(win)
    local winnr = vim.api.nvim_win_get_number(win)
    return reset .. (" [%d] %%f"):format(winnr)
end

vim.api.nvim_create_autocmd("WinEnter", {
    group = group,
    callback = function()
        local cur_win_id = vim.api.nvim_get_current_win()
        -- If we're currently in a float, don't change anything.
        if is_float_win(cur_win_id) then return end

        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_is_valid(win) and not is_float_win(win) then
                vim.wo[win].winbar = inactive_winbar(win)
            end
        end

        if package.loaded["dropbar"] then vim.wo[cur_win_id].winbar = "%!v:lua.dropbar()" end
    end,
})
