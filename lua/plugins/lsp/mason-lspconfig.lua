return {
    "williamboman/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "lua_ls",
            "clangd",
            "bashls",
            "rust_analyzer",
        },
    },
    cmd = "Mason",
    event = "LspAttach",
}
