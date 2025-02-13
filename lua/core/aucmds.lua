local aucmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

aucmd(
    { "BufRead", "BufNewFile" },
    { pattern = { "*.frag,*.vert" }, command = ":set filetype=glsl" }
)
-- aucmd({ "BufRead", "BufNewFile" }, {
--     pattern = "COMMIT_EDITMSG",
--     command = ":set colorcolumn=50,72",
-- })

-- callback for lua function callbacks
-- pattern can be left out, if for all files
-- aucmd({ 'CursorHold' }, { callback = function() vim.diagnostic.open_float() end,})

aucmd({ "TextYankPost" }, {
    callback = function()
        vim.highlight.on_yank()
    end,
})

aucmd({ "VimEnter", "WinEnter" }, {
    group = create_augroup("TrailingSpace", { clear = true }),
    pattern = "defx",
    command = "highlight clear TrailingSpaces",
})

aucmd("BufWritePre", {
    group = create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        local file = event.match
        -- Ignore creation of oil:// directories, which get created on each save in an Oil.nvim buffer.
        if file:match("^oil://") then
            return
        end
        local dir = vim.fn.fnamemodify(file, ":p:h")
        if vim.fn.isdirectory(dir) == 1 then
            return
        end
        vim.fn.mkdir(dir, "p")
    end,
})
