return {
    "folke/snacks.nvim",
    keys = {
        {
            "<c-/>",
            function()
                Snacks.terminal()
            end,
            desc = "Toggle Terminal",
        },
        {
            "<c-_>",
            function()
                Snacks.terminal()
            end,
            desc = "which_key_ignore",
        },
    },
    ---@type snacks.Config
    opts = {
        -- your terminal configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        terminal = {},
    },
}
