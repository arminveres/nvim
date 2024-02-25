return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        config = {
            shortcut = {
                { desc = "Lazy Plugin Manager ", group = "@lsp.type.class", action = "Lazy", key = "l" },
                { desc = "󰊳 Update ", group = "@method", action = "Lazy update", key = "u" },
                {
                    icon = " ",
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
