local capabilities = vim.lsp.protocol.make_client_capabilities()

local function on_attach(client, bufnr)
    -- enable snipper support
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- update default nvim capabilities with those of cmp
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    -- Highlight words under current cursor
    local illuminate = require("illuminate")
    illuminate.on_attach(client)
end

local function setup()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        local lsp_opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

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

        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        -- while not handled by LspSaga, we want specific goto next/prev error
        vim.keymap.set("n", "]e", function()
            vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, opts)
        vim.keymap.set("n", "[e", function()
            vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, opts)

        -- ================================================================================================
        -- LSP Saga
        -- ================================================================================================
        -- Further remaps can be found under lspsaga/command.lua
        vim.keymap.set("n", "[d", function()
            -- vim.cmd("Lspsaga diagnostic_jump_prev")
            require("lspsaga.diagnostic"):goto_prev()
        end, opts)
        vim.keymap.set("n", "]d", function()
            -- vim.cmd("Lspsaga diagnostic_jump_next")
            require("lspsaga.diagnostic"):goto_next()
        end, opts)
        vim.keymap.set("n", "K", function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
                -- vim.lsp.buf.hover()
                vim.cmd([[Lspsaga hover_doc]])
            end
        end, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", function()
            -- ":Lspsaga code_action<CR>"
            require("lspsaga.codeaction"):code_action()
        end, opts)
        vim.keymap.set("n", "grn", function()
            vim.cmd([[Lspsaga rename ++project]])
        end, opts)
        vim.keymap.set("n", "gh", function()
            vim.cmd("Lspsaga finder")
        end, opts)
        vim.keymap.set("n", "<leader>at", function()
            -- ":Lspsaga outline<CR>"
            require("lspsaga.symbol"):outline()
        end, opts)
        vim.keymap.set("n", "gl", function()
            vim.cmd([[Lspsaga show_line_diagnostics]])
        end, opts)
        vim.keymap.set("n", "<leader>gl", function()
            vim.cmd([[Lspsaga show_cursor_diagnostics]])
        end, opts)
        vim.keymap.set("n", "<Leader>ci", function()
            vim.cmd([[Lspsaga incoming_calls]])
        end)
        vim.keymap.set("n", "<Leader>co", function()
            vim.cmd([[Lspsaga outgoing_calls]])
        end)

        -- keymap("n", "<leader>rn", ":Lspsaga rename ++project<CR>", opts)
        -- keymap("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)
        -- keymap("n", "<leader>gd", "<cmd>Lspsaga preview_definition<CR>", opts)

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
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "RRethy/vim-illuminate",
    },
}
