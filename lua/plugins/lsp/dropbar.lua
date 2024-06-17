return {
    "Bekaboo/dropbar.nvim",
    keys = {
        {
            "<leader>o",
            function()
                require("dropbar.api").pick()
            end,
        },
    },
    opts = {},
    -- optional, but required for fuzzy finder support
    dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
