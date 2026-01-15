local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set

local merge_desc = require("core.utils").merge_desc

vim.diagnostic.config({
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "", -- ""
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
        texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
        numhl = {},
        linehl = {},
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
})

autocmd("LspAttach", {
    group = augroup("pluginsLspConfig", {}),
    callback = function(args)
        -- ========================================================================================
        -- Buffer local mappings.
        -- ========================================================================================
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = args.buf }
        map("n", "gD", vim.lsp.buf.declaration, merge_desc(opts, "[g]o to [D]eclaration"))
        map("n", "gd", vim.lsp.buf.definition, merge_desc(opts, "[g]o to [d]efinition"))
        map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        map(
            "n",
            "<leader>bf",
            function() vim.lsp.buf.format({ async = true }) end,
            merge_desc(opts, "[b]uffer [f]ormat")
        )
        map("n", "gsi", vim.lsp.buf.incoming_calls, merge_desc(opts, "Show incoming lsp call"))
        map("n", "gso", vim.lsp.buf.outgoing_calls, merge_desc(opts, "Show incoming lsp call"))

        -- map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- map('n', '<space>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)

        map(
            "n",
            "]e",
            function()
                vim.diagnostic.jump({
                    count = 1,
                    float = true,
                    severity = vim.diagnostic.severity.ERROR,
                })
            end,
            opts
        )
        map(
            "n",
            "[e",
            function()
                vim.diagnostic.jump({
                    count = -1,
                    float = true,
                    severity = vim.diagnostic.severity.ERROR,
                })
            end,
            opts
        )
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        -- map("n", "gld", function() vim.diagnostic.open_float() end, opts)

        -- ========================================================================================
        -- Provider specific options
        -- ========================================================================================
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            vim.notify("ERROR opening client", vim.diagnostic.severity.ERROR)
            return
        end

        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true)

            map(
                "n",
                "<Leader>lh",
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                { desc = "Toggle [L]SP Inlay [H]int" }
            )
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

        -- vim.lsp.log.set_format_func(vim.inspect)

        -- NOTE(aver): ensure lsp logs don't get too large
        -- rotate_log()
    end,
})
