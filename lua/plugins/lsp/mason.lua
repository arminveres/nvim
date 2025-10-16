return {
    {
        "mason-org/mason.nvim", -- installer for lsps
        -- event = "VeryLazy",
        opts = { ui = { border = "rounded" } },
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "lua_ls",
                "clangd",
                "bashls",
                "basedpyright",
            },
            -- I am setting up my servers anyhow
            automatic_enable = false,
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
                "shellcheck",
            },
            automatic_installation = false,
            automatic_setup = true, -- Recommended, but optional
            dependencies = { "nvimtools/none-ls.nvim" },
        },
    },
}
