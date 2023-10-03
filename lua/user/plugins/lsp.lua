return {
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    "nvimtools/none-ls.nvim", -- Null LS
    "williamboman/mason.nvim", -- installer for lsps
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",
    "p00f/clangd_extensions.nvim", -- Clangd's off-spec features for neovim's LSP client
    "simrat39/rust-tools.nvim",
    {
        "folke/neodev.nvim",
        opts = {},
    },
    {
        -- give IntelliJ like lens features
        "VidocqH/lsp-lens.nvim",
        event = "LspAttach",
        config = true,
    },
    {
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
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-treesitter/nvim-treesitter" },
        },
    },
}
