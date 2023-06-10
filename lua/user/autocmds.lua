local aucmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

aucmd({ "BufRead,BufNewFile" }, { pattern = { "*.frag,*.vert" }, command = ":set filetype=glsl" })
aucmd({ "BufRead,BufNewFile" }, {
    pattern = "COMMIT_EDITMSG",
    command = ":set colorcolumn=50,72",
})
aucmd({ "BufReadPost,FileReadPost" }, { command = ":normal zR" })

-- callback for lua function callbacks
-- pattern can be left out, if for all files
-- aucmd({ 'CursorHold' }, { callback = function() vim.diagnostic.open_float() end,})

aucmd({ "TextYankPost" }, {
    callback = function()
        vim.highlight.on_yank()
    end,
})

create_augroup("TrailingSpace", { clear = false })
aucmd(
    { "VimEnter,WinEnter" },
    { pattern = "defx", group = "TrailingSpace", command = "highlight clear TrailingSpaces" }
)

aucmd("BufWritePre", {
    group = create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        local file = vim.loop.fs_realpath(event.match) or event.match

        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        local backup = vim.fn.fnamemodify(file, ":p:~:h")
        backup = backup:gsub("[/\\]", "%%")
        vim.go.backupext = backup
    end,
})

aucmd("BufEnter", {
    group = create_augroup("TermAlwaysInsert", { clear = true }),
    pattern = "term://*toggleterm*",
    command = "startinsert"
})

-- aucmd("VimEnter,WinEnter", {
--   group = create_augroup("TelescopeOnEmptyBuffer", { clear = true }),
--   callback = function()
--     if vim.bo.filetype == "" then
--       local builtin = require("telescope.builtin")
--       builtin.find_files({
--         mode = "insert",
--         hidden = true,
--       })
--     end
--   end,
-- })
