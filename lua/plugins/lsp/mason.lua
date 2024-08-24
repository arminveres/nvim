return {
    {
        "williamboman/mason.nvim", -- installer for lsps
        event = "VeryLazy",
        opts = {
            ui = { border = "rounded" },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "lua_ls",
                "clangd",
                "bashls",
                "rust_analyzer",
                "basedpyright",
            },
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                -- Opt to list sources here, when available in mason.
                "stylua",
                "jq",
                "shfmt",
                "gitlint",
            },
            automatic_installation = false,
            automatic_setup = true, -- Recommended, but optional
        },
    },
}
