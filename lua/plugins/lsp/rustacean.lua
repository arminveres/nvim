vim.g.rustaceanvim = {
    server = {
        default_settings = {
            ["rust-analyzer"] = {
                diagnostics = {
                    enable = true,     -- Enable live diagnostics
                    experimental = {
                        enable = true, -- Enable experimental features
                    },
                },
            },
        },
    },
}

return {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false,   -- This plugin is already lazy
}
