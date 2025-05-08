local function on_attach(client, bufnr)
    -- Highlight words under current cursor
    require("illuminate").on_attach(client)
end

-- @brief Sets up individual language servers
local function init()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- enable snippet support
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- update default nvim capabilities with those of cmp
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = true,
        lineFoldingOnly = true,
    }
    capabilities.textDocument.semanticTokens.multilineTokenSupport = true

    vim.lsp.config("*", { capabilities = capabilities, on_attach = on_attach })

    local lsp_servers = require("mason-lspconfig").get_installed_servers()

    -- FIXME(aver): For some reason, mason does not recognize the installed server
    table.insert(lsp_servers, "bitbake_ls")
    table.insert(lsp_servers, "nixd")

    vim.lsp.enable(lsp_servers)
end

return {
    {
        "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
        -- needs to be init, otherwise not ready to setup and lazy load
        init = init,
        -- allow lazyloading on these events, otherwise it does not load correctly
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        keys = {
            { "<Leader>li", vim.cmd.LspInfo, desc = "Open [l]sp [i]nfo" },
            { "<Leader>lr", vim.cmd.LspRestart, desc = "[l]sp [r]estart" },
            { "<Leader>ll", vim.cmd.LspLog, desc = "Open [l]sp [l]og" },
        },

        dependencies = {
            "RRethy/vim-illuminate",
            { "Decodetalkers/csharpls-extended-lsp.nvim", ft = "cs" },
        },
    },
}
