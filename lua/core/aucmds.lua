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
        local file = vim.uv.fs_realpath(event.match)
        if not file then
            return
        end

        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        local backup = vim.fn.fnamemodify(file, ":p:~:h")
        backup = backup:gsub("[/\\]", "%%")
        vim.go.backupext = backup
    end,
})


    end,
})
