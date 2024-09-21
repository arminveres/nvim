return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        config = {
            shortcut = {
                {
                    desc = "Open new buffer ",
                    group = "@property",
                    action = ":enew | startinsert",
                    key = "i",
                },
                {
                    desc = "Lazy Plugin Manager ",
                    group = "@lsp.type.class",
                    action = "Lazy",
                    key = "l",
                },
                {
                    icon = "󰊳  ",
                    icon_hl = "@variable",
                    desc = "Lazy Sync ",
                    group = "@method",
                    action = "Lazy sync",
                    key = "s",
                },
                {
                    icon = "󰊳  ",
                    icon_hl = "@variable",
                    desc = "Lazy Profile ",
                    group = "@method",
                    action = "Lazy profile",
                    key = "p",
                },
                {
                    icon = "  ",
                    icon_hl = "@variable",
                    desc = "Files ",
                    group = "Label",
                    action = "Telescope find_files",
                    key = "f",
                },
                {
                    icon = "  ",
                    icon_hl = "@variable",
                    desc = "Old Files ",
                    group = "Label",
                    action = "Telescope oldfiles",
                    key = "o",
                },
                { desc = "Quit ", group = "@property", action = ":qa", key = "q" },
            },
        },
    },
}
