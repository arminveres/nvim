local merge_desc = require("core.utils").merge_desc

--- @brief Trims log on startup, to ensure timely log checks
local function rotate_log()
    local log_path = vim.fn.stdpath("state") .. "/lsp.log"
    local backup_path = log_path .. ".old"

    local stat = vim.loop.fs_stat(log_path)
    if stat and stat.size > 1024 * 1024 then -- Limit to 1 MB
        -- Rename the current log file
        local succ, msg = os.rename(log_path, backup_path)
        -- local succ, msg = os.remove(log_path)
        if not succ then
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.notify(msg, vim.log.levels.ERROR)
            return
        end
        vim.notify("Neovim log rotated", vim.log.levels.INFO)
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- enable snippet support
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- update default nvim capabilities with those of cmp
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

local function on_attach(client, bufnr)
    -- Highlight words under current cursor
    require("illuminate").on_attach(client)
end

-- @brief Sets up individual language servers
local function setup()
    local lsp_servers = require("mason-lspconfig").get_installed_servers()
    -- FIXME(aver): For some reason, mason does not recognize the installed server
    table.insert(lsp_servers, "bitbake_ls")
    vim.lsp.enable(lsp_servers)
    vim.lsp.config("*", { capabilities = capabilities, on_attach = on_attach })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("pluginsLspConfig", {}),
        callback = function(args)
            -- ========================================================================================
            -- Buffer local mappings.
            -- ========================================================================================
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = args.buf }
            vim.keymap.set(
                "n",
                "gD",
                vim.lsp.buf.declaration,
                merge_desc(opts, "[g]o to [D]eclaration")
            )
            vim.keymap.set(
                "n",
                "gd",
                vim.lsp.buf.definition,
                merge_desc(opts, "[g]o to [d]efinition")
            )
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
            vim.keymap.set(
                "n",
                "<bslash>bf",
                function() vim.lsp.buf.format({ async = true }) end,
                merge_desc(opts, "[b]uffer [f]ormat")
            )
            vim.keymap.set(
                "n",
                "gsi",
                vim.lsp.buf.incoming_calls,
                merge_desc(opts, "Show incoming lsp call")
            )
            vim.keymap.set(
                "n",
                "gso",
                vim.lsp.buf.outgoing_calls,
                merge_desc(opts, "Show incoming lsp call")
            )

            -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            -- vim.keymap.set('n', '<space>wl', function()
            --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            -- end, opts)

            vim.keymap.set(
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
            vim.keymap.set(
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
            vim.keymap.set(
                "n",
                "]d",
                function() vim.diagnostic.jump({ count = 1, float = true }) end,
                opts
            )
            vim.keymap.set(
                "n",
                "[d",
                function() vim.diagnostic.jump({ count = -1, float = true }) end,
                opts
            )
            -- vim.keymap.set("n", "gld", function() vim.diagnostic.open_float() end, opts)

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

                vim.keymap.set(
                    "n",
                    "<Leader>lh",
                    function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                    { desc = "Toggle [L]SP Inlay [H]int" }
                )
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

            vim.lsp.log.set_format_func(vim.inspect)

            vim.diagnostic.config({ virtual_text = false })

            -- NOTE(aver): ensure lsp logs don't get too large
            rotate_log()
        end,
    })
end

return {
    {
        "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
        init = setup,
        -- allow lazyloading on these events, otherwise it does not load correctly
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        keys = {
            { "<Leader>li", vim.cmd.LspInfo, desc = "Open [l]sp [i]nfo" },
            { "<Leader>lr", vim.cmd.LspRestart, desc = "[l]sp [r]estart" },
            { "<Leader>ll", vim.cmd.LspLog, desc = "Open [l]sp [l]og" },
        },

        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "RRethy/vim-illuminate",
        },
    },
    { "Decodetalkers/csharpls-extended-lsp.nvim", ft = "cs" },
}
