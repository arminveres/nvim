return {
    "Bekaboo/dropbar.nvim",
    event = "VimEnter",
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
                    -- "BufModifiedSet", -- BUG: deprecated
                    "FileChangedShellPost",
                    "TextChanged",
                    "ModeChanged",
                },
            },
        },
    },
}
