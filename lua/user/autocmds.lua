local aucmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

aucmd(
    { "BufRead", "BufNewFile" },
    { pattern = { "*.frag,*.vert" }, command = ":set filetype=glsl" }
)
aucmd({ "BufRead", "BufNewFile" }, {
    pattern = "COMMIT_EDITMSG",
    command = ":set colorcolumn=50,72",
})
-- aucmd({ "BufReadPost", "FileReadPost" }, { command = ":normal zR" })

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
    command = "startinsert",
})

-- ================================================================================================
-- Configure QMK.nvim for multiple layouts
-- ================================================================================================
local qmk_group = create_augroup("MyQMK", {})
local qmk_path = "*sofle/keymaps/arminveres/keymap.c"
aucmd("BufEnter", {
    desc = "Format simple keymap",
    group = qmk_group,
    pattern = qmk_path,
    callback = function()
        require("qmk").setup({
            auto_format_pattern = "*sofle/keymaps/arminveres/keymap.c",
            name = "LAYOUT",
            layout = {
                "x x x x x x _ _ _ x x x x x x",
                "x x x x x x _ _ _ x x x x x x",
                "x x x x x x _ _ _ x x x x x x",
                "x x x x x x x _ x x x x x x x",
                "_ _ x x x x x _ x x x x x _ _",
            },
        })
    end,
})

qmk_path = "*moonlander/keymaps/arminveres/keymap.c"
aucmd("BufEnter", {
    desc = "Format simple keymap",
    group = qmk_group,
    pattern = qmk_path,
    callback = function()
        require("qmk").setup({
            auto_format_pattern = qmk_path,
            name = "LAYOUT_moonlander",
            layout = {
                "x x x x x x x _ x x x x x x x",
                "x x x x x x x _ x x x x x x x",
                "x x x x x x x _ x x x x x x x",
                "x x x x x x _ _ _ x x x x x x",
                "x x x x x _ x _ x _ x x x x x",
                "_ _ _ x x x _ _ _ x x x _ _ _",
            },
        })
    end,
})
