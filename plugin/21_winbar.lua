-- Create an autocommand group for winbar customization
local group = vim.api.nvim_create_augroup("WinbarCustomization", { clear = true })

local function is_float_win(win_id)
    local win_config = vim.api.nvim_win_get_config(win_id)
    if win_config.relative ~= "" then return true end
    return false
end

vim.api.nvim_create_autocmd("WinEnter", {
    group = group,
    callback = function()
        local cur_win_id = vim.api.nvim_get_current_win()
        -- If we're currently in a float, don't change anything.
        if is_float_win(cur_win_id) then return end

        -- For each valid floating window, reset and format
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_is_valid(win) and not is_float_win(win) then
                -- Full reset: drop any stale winhl dimming (e.g. left over from dropbar's focus-dim tracking after a
                -- float steals/returns focus) before recomputing the winbar for this window.
                vim.wo[win].winhl = ""
                vim.wo[win].winbar = (" [%d] %%f"):format(vim.api.nvim_win_get_number(win))
            end
        end

        if package.loaded["dropbar"] then vim.wo[cur_win_id].winbar = "%!v:lua.dropbar()" end
    end,
})
