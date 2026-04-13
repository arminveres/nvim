return {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
        {
            "<leader>e",
            function() require("oil").toggle_float() end,
            desc = "Open parent directory",
        },
        {
            "<leader>E",
            "<cmd>Oil<cr>",
            desc = "Open parent directory",
        },
    },
    opts = {
        default_file_explorer = true,
        float = {
            max_width = 120,
            max_height = 40,
            border = vim.g.BorderStyle,
        },
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
        view_options = { show_hidden = true },
        confirmation = { border = vim.g.BorderStyle },
        progress = { border = vim.g.BorderStyle },
        ssh = { border = vim.g.BorderStyle },
        keymaps_help = { border = vim.g.BorderStyle },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
}
