-- @brief Sets up individual language servers
local function setup_lsp()
    local on_attach = function(client, bufnr)
        -- Highlight words under current cursor
        require("illuminate").on_attach(client)
    end

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
    vim.lsp.config("*", { capabilities = capabilities, on_attach = on_attach })

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
    })
end

return {
    {
        "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
        config = setup_lsp,
    },
    { "RRethy/vim-illuminate" },
}
