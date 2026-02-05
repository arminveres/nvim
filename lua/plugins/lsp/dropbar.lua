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
        menu = {
            win_configs = {
                border = "rounded", -- Border style for the menu
            },
        },
    },
}
