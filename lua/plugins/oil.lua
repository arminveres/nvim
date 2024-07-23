return {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    opts = {
        default_file_explorer = true,
        float = { max_width = 120, max_height = 230 },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "<leader>e",
            function()
                require("oil").toggle_float()
            end,
            desc = "Open parent directory",
        },
    },
}
