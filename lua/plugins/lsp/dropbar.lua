return {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>o",
            function() require("dropbar.api").pick() end,
            desc = "Dropbar [o]pen",
        },
    },
    opts = {
        bar = {
            update_events = {
                buf = {
                    "FileChangedShellPost",
                    "TextChanged",
                    "ModeChanged",
                },
            },
        },
    },
}
