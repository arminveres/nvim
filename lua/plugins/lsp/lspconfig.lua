local capabilities = vim.lsp.protocol.make_client_capabilities()

local function on_attach(client, bufnr)
    -- enable snipper support
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- update default nvim capabilities with those of cmp
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    -- Highlight words under current cursor
    require("illuminate").on_attach(client)
    require("nvim-navic").attach(client, bufnr)
end

local function setup()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        local lsp_opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        if server == "lua_ls" then
            local lua_opts = require("plugins.lsp.settings.lua_ls")
            lsp_opts = vim.tbl_deep_extend("force", lua_opts, lsp_opts)
        elseif server == "clangd" then
            local clangd_opts = require("plugins.lsp.settings.clangd").server_opts
            lsp_opts = vim.tbl_deep_extend("force", clangd_opts, lsp_opts)
        end

        lspconfig[server].setup(lsp_opts)
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- ========================================================================================
        -- Buffer local mappings.
        -- ========================================================================================
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>bf", function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "]e", function()
            vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, opts)
        vim.keymap.set("n", "[e", function()
            vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        -- ========================================================================================
        -- Provider specific options
        -- ========================================================================================
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            vim.notify("ERROR opening client", vim.diagnostic.severity.ERROR)
            return
        end

        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            local is_enabled = true
            vim.lsp.inlay_hint.enable(args.buf, is_enabled)

            vim.keymap.set("n", "<Leader>lh", function()
                is_enabled = not is_enabled
                vim.lsp.inlay_hint.enable(args.buf, is_enabled)
            end, { desc = "Toggle [L]SP Inlay [H]int" })
        end

        -- if client.server_capabilities.codeActionProvide.codeActionKind then
        -- end

        -- NOTE: Format on save autocommand
        -- if client.server_capabilities.documentFormattingProvider then
        --     vim.api.nvim_create_autocmd({ "BufWrite" }, {
        --         group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
        --         callback = function()
        --             -- WARN: use false, otherwise not possible to save
        --             vim.lsp.buf.format({ async = false })
        --         end,
        --     })
        -- end
    end,
})

return {
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    config = setup,
    keys = {
        { "<Leader>li", ":LspInfo<CR>", desc = "Open [l]sp [i]nfo" },
        { "<Leader>ll", ":LspLog<CR>", desc = "Open [l]sp [l]og" },
        { "<Leader>lr", ":LspRestart<CR>", desc = "[l]sp [r]estart" },
    },
    dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "RRethy/vim-illuminate",
        "SmiteshP/nvim-navic",
    },
}