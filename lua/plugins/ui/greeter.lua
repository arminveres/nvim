return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = "echasnovski/mini.icons",
    opts = {
        config = {
            shortcut = {
                {
                    desc = "Lazy Plugin Manager ",
                    group = "@lsp.type.class",
                    action = "Lazy",
                    key = "l",
                },
                {
                    icon = "󰊳  ",
                    icon_hl = "@variable",
                    desc = "Sync ",
                    group = "@method",
                    action = "Lazy sync",
                    key = "s",
                },
                {
                    icon = "  ",
                    icon_hl = "@variable",
                    desc = "Files ",
                    group = "Label",
                    action = "Telescope find_files",
                    key = "f",
                },
                { desc = "Quit ", group = "@property", action = ":qa", key = "q" },
            },
        },
    },
}
