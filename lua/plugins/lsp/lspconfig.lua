local function on_attach(client, bufnr)
    -- Highlight words under current cursor
    require("illuminate").on_attach(client)
end

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

    vim.lsp.config("*", { capabilities = capabilities, on_attach = on_attach })

    local lsp_servers = require("mason-lspconfig").get_installed_servers()

    -- FIXME(aver): For some reason, mason does not recognize the installed server
    table.insert(lsp_servers, "bitbake_ls")
    table.insert(lsp_servers, "nixd")

    vim.lsp.enable(lsp_servers)
end

return {
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    config = setup_lsp,
    -- Allow lazyloading on these events, otherwise it does not load correctly
    event = "VeryLazy",
    keys = {
        {
            "<Leader>li",
            function() vim.cmd.checkhealth("vim.lsp") end,
            desc = "Open [l]sp [i]nfo",
        },
        { "<Leader>lr", function() vim.cmd.lsp("restart") end, desc = "[l]sp [r]estart" },
        -- { "<Leader>ll", vim.cmd.LspLog,         desc = "Open [l]sp [l]og" },
    },

    dependencies = {
        "RRethy/vim-illuminate",
        { "Decodetalkers/csharpls-extended-lsp.nvim", ft = "cs" },
    },
}
