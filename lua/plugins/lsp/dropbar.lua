return {
    "Bekaboo/dropbar.nvim",
    lazy = false,
    keys = {
        {
            "<leader>o",
            function() require("dropbar.api").pick() end,
            desc = "Dropbar [o]pen",
        },
    },
}
