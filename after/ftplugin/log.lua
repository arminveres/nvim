-- strip ANSI escape sequences so builtin log syntax highlighting isn't broken by them
vim.api.nvim_buf_call(0, function()
    if vim.b.ansi_stripped then return end
    vim.b.ansi_stripped = true
    vim.cmd([[silent! keepjumps keeppatterns %s/\%x1b\[[0-9;]*[mK]//ge]])
    vim.bo.modified = false
end)
