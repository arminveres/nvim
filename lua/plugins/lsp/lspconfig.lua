-- @brief Sets up individual language servers
local function setup_lsp()
    local capabilities = {
        -- enable snippet support
        textDocument = {
            -- completion.completionItem.snippetSupport = true,
            foldingRange = {
                dynamicRegistration = true,
                lineFoldingOnly = true,
            },
            semanticTokens = { multilineTokenSupport = true },
        },
    }

    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

    -- update capabilities and on_attach function for all configs
    vim.lsp.config("*", { capabilities = capabilities })

    -- Windows still uses mason
    if vim.fn.has("win32") == 1 then
        local lsp_servers = require("mason-lspconfig").get_installed_servers()
        vim.lsp.enable(lsp_servers)
    end

    -- enable selected lsps, installed externally.
    vim.lsp.enable({
        "bitbake_ls",
        "nixd",
        "clangd",
        "lua_ls",
        "basedpyright",
        "bashls",
        "yamlls",
        "jsonls",
        "neocmake",
        "taplo",
        "systemd_lsp",
        "dockerls",
    })
end

return {
    {
        "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
        config = setup_lsp,
    },
}
