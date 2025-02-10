return {
    "folke/snacks.nvim",
    lazy = false,
    keys = {
        {
            "<leader>lg",
            function()
                Snacks.lazygit()
            end,
            desc = "Lazygit",
        },
    },
    ---@type snacks.Config
    opts = {
        -- your lazygit configuration comes here or leave it empty to use the default settings
        -- refer to the configuration section below
        lazygit = {},
    },
}
