-- ================================================================================================
-- Configure QMK.nvim for multiple layouts
-- ================================================================================================
local qmk_group = vim.api.nvim_create_augroup("QMK", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format simple keymap",
    group = qmk_group,
    pattern = "*sofle/rev1/keymaps/arminveres/keymap.c",
    callback = function()
        require("qmk").setup({
            auto_format_pattern = "none",
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

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Format simple keymap",
    group = qmk_group,
    pattern = "*moonlander/keymaps/arminveres/keymap.c",
    callback = function()
        require("qmk").setup({
            auto_format_pattern = "none",
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

return {
    "codethread/qmk.nvim",
    event = "BufEnter *arminveres/keymap.c",
}
