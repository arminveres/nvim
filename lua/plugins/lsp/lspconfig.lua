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

    vim.lsp.config("*", { capabilities = capabilities, on_attach = on_attach })

    local lsp_servers = require("mason-lspconfig").get_installed_servers()

    -- manually insert servers, that are not recognized
    table.insert(lsp_servers, "bitbake_ls")
    table.insert(lsp_servers, "nixd")

    vim.lsp.enable(lsp_servers)
end

return {
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    lazy = false,
    config = setup_lsp,
    -- Allow lazyloading on these events, otherwise it does not load correctly
    -- event = "VeryLazy",
    keys = {
        {
            "<Leader>li",
            function() vim.cmd.checkhealth("vim.lsp") end,
            desc = "Open [l]sp [i]nfo",
        },
        { "<Leader>lr", function() vim.cmd.lsp("restart") end, desc = "[l]sp [r]estart" },
        {
            "<Leader>ll",
            function() vim.cmd("tabnew " .. vim.lsp.log.get_filename()) end,
            desc = "Open [l]sp [l]og",
        },
    },

    dependencies = { "RRethy/vim-illuminate" },
}
