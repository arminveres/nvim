return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        dashboard = {
            -- your dashboard configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            header = require("extras.ascii-art").arasaka_ascii_xl,
        },
    },
}
