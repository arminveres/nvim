return {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    opts = {
        ui = {
            title = true,
            border = "shadow",
            winblend = 15,
            code_action_icon = "💡", --
        },
        rename = {
            in_select = false, -- I don't see why we should be in select mode, caused me a lot of headaches
        },
        code_action = {
            extend_gitsigns = true, -- use gitsign either through lspsaga or null-ls
        },
        symbol_in_winbar = {
            enable = true,
        },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter",
        "kevinhwang91/nvim-ufo",
    },
}
