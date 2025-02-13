return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        dashboard = {
            preset = { header = require("extras.ascii-art").arasaka_ascii_m },
            -- your dashboard configuration comes here or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
}
