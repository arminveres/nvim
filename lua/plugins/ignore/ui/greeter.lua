return {
    "nvimdev/dashboard-nvim",
    enabled = false,
    -- event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        theme = "doom",
        config = {
            header = require("extras.ascii-art").arasaka_ascii_m,
            center = {
                {
                    desc = "Open new buffer ",
                    action = ":enew | startinsert",
                    key = "i",
                },
                {
                    desc = "Lazy Plugin Manager ",
                    action = "Lazy",
                    key = "l",
                },
                {
                    desc = "Lazy Sync ",
                    action = "Lazy sync",
                    key = "s",
                },
                {
                    desc = "Lazy Profile ",
                    action = "Lazy profile",
                    key = "p",
                },
                {
                    desc = "Files ",
                    action = "Telescope find_files",
                    key = "f",
                },
                {
                    desc = "Old Files ",
                    action = "Telescope oldfiles",
                    key = "o",
                },
                { desc = "Quit ", action = ":qa", key = "q" },
            },
        },
    },
}
