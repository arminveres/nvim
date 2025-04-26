return {
    -- NOTE: See further config at lua/user/autocmds.lua
    "codethread/qmk.nvim",
    event = "BufEnter *arminveres/keymap.c",
    config = function()
        -- ================================================================================================
        -- Configure QMK.nvim for multiple layouts
        -- ================================================================================================
        local aucmd = vim.api.nvim_create_autocmd
        local create_augroup = vim.api.nvim_create_augroup
        local qmk_group = create_augroup("MyQMK", {})
        local qmk_path = "*sofle/rev1/keymaps/arminveres/keymap.c"
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
    end,
}
