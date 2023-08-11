local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
    vim.notify("mason not ok")
    return
end

mason.setup({
    ui = {
        border = "rounded",
    },
})

local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok then
    return
end

local settings = {
    -- refer to documentation https://github.com/williamboman/mason-lspconfig.nvim
}
lsp_installer.setup({
    ensure_installed = { "lua_ls", "clangd", "bashls" },
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}

for _, server in ipairs(lsp_installer.get_installed_servers()) do
    opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    if server == "lua-language-server" then
        local lua_opts = require("user.lsp.settings.lua_ls")
        opts = vim.tbl_deep_extend("force", lua_opts, opts)
    end

    if server == "pyright" then
        local pyright_opts = require("user.lsp.settings.pyright")
        opts = vim.tbl_deep_extend("force", pyright_opts, opts)
    end

    if server == "pylsp" then
        local pylsp_opts = require("user.lsp.settings.pylsp")
        opts = vim.tbl_deep_extend("force", pylsp_opts, opts)
    end

    if server == "bashls" then
        local bashls_opts = require("user.lsp.settings.bashls")
        opts = vim.tbl_deep_extend("force", bashls_opts, opts)
    end

    if server == "ltex" then
        local ltex_opts = require("user.lsp.settings.ltex")
        opts = vim.tbl_deep_extend("force", ltex_opts, opts)
    end


    if server == "clangd" then
        local clangd_opts = require("user.lsp.settings.clangd").server_opts
        opts = vim.tbl_deep_extend("force", clangd_opts, opts)
    end

    if server == "rust_analyzer" then
        require('user.lsp.settings.rust')
    else -- WARN: Never remove this, this sets up the lsp for every server except for clangd
        lspconfig[server].setup(opts)
    end
end
