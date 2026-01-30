-- Trim whitespace command
vim.api.nvim_create_user_command("TrimWhitespace", function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
end, { desc = "trim trailing whitespace" })
