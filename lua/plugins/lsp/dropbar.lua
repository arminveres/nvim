return {
    "Bekaboo/dropbar.nvim",
    keys = {
        {
            "<leader>o",
            function() require("dropbar.api").pick() end,
            desc = "Dropbar [o]pen",
        },
    },
    opts = {},
}
