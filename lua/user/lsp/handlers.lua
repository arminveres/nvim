local M = {}
local merge_desc = require("user.utils").merge_desc

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" }, -- ""
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        -- disable virtual text
        virtual_text = true,
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    -- NOTE: not really neede anymore, because replacement with lspsaga.
    -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    --   border = 'rounded',
    -- })
    -- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    --   border = 'rounded',
    -- })
end

local function lsp_highlight_document(client)
    -- if client.server_capabilities.document_highlight then
    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        return
    end
    illuminate.on_attach(client)
    -- end
end

M.on_attach = function(client, bufnr)
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not status_ok then
        print("cmp failed!!!")
        return
    end

    M.capabilities.textDocument.completion.completionItem.snippetSupport = true
    M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

    lsp_highlight_document(client)
end

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

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
        end, merge_desc(opts, "Format current Buffer"))

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
        vim.keymap.set("n", "[d", ":Lspsaga diagnostic_jump_prev<CR>", opts)
        vim.keymap.set("n", "]d", ":Lspsaga diagnostic_jump_next<CR>", opts)
        vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", ":Lspsaga code_action<CR>", opts)
        vim.keymap.set("n", "grn", ":Lspsaga rename ++project<CR>", opts)
        vim.keymap.set("n", "gh", ":Lspsaga finder<CR>", opts)
        vim.keymap.set("n", "<leader>at", ":Lspsaga outline<CR>", opts)
        vim.keymap.set("n", "gl", ":Lspsaga show_line_diagnostics<CR>", opts)
        vim.keymap.set("n", "<leader>gl", ":Lspsaga show_cursor_diagnostics<CR>", opts)
        vim.keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
        vim.keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
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

        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(args.buf, true)
        end

        -- if client.server_capabilities.codeActionProvide.codeActionKind then
        -- end

        -- NOTE: Format on save autocommand
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd({ "BufWrite" }, {
                group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
                callback = function()
                    -- WARN: use false, otherwise not possible to save
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
})

return M
