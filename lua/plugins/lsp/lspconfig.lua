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
    -- require("clangd_extensions.inlay_hints").setup_autocmd()
end

-- @brief Sets up individual language servers
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
        elseif server == "pyright" then
            local pyright_opts = require("plugins.lsp.settings.pyright")
            lsp_opts = vim.tbl_deep_extend("force", pyright_opts, lsp_opts)
        elseif server == "pylizer" then
            local pylyzer_opts = require("plugins.lsp.settings.pylizer")
            lsp_opts = vim.tbl_deep_extend("force", pylyzer_opts, lsp_opts)
        elseif server == "pylsp" then
            local pylsp_opts = require("plugins.lsp.settings.pylsp")
            lsp_opts = vim.tbl_deep_extend("force", pylsp_opts, lsp_opts)
        elseif server == "bashls" then
            local bashls_opts = require("plugins.lsp.settings.bashls")
            lsp_opts = vim.tbl_deep_extend("force", bashls_opts, lsp_opts)
        elseif server == "ltex" then
            local ltex_opts = require("plugins.lsp.settings.ltex")
            lsp_opts = vim.tbl_deep_extend("force", ltex_opts, lsp_opts)
        elseif server == "texlab" then
            local texlab_opts = require("plugins.lsp.settings.texlab")
            lsp_opts = vim.tbl_deep_extend("force", texlab_opts, lsp_opts)
        elseif server == "marksman" then
            local marksman_opts = require("plugins.lsp.settings.marksman")
            lsp_opts = vim.tbl_deep_extend("force", marksman_opts, lsp_opts)
        elseif server == "jsonls" then
            local jsonls_opts = require("plugins.lsp.settings.jsonls")
            lsp_opts = vim.tbl_deep_extend("force", jsonls_opts, lsp_opts)
        end

        if server ~= "rust_analyzer" then
            lspconfig[server].setup(lsp_opts)
        end
    end

    -- setup sourcekit on MacOS, ignore on other systems
    if vim.uv.os_uname().sysname:match("Darwin") then
        lspconfig["sourcekit"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = lspconfig.util.root_pattern(
                ".git",
                "Package.swift",
                "compile_commands.json"
            ),
        })

        -- NixOS specific setups
    elseif vim.uv.os_uname().version:match("NixOS") then
        lspconfig.marksman.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = require("lspconfig.util").root_pattern(
                ".git",
                ".marksman.toml",
                "README.md"
            ),
        })

        lspconfig.nixd.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = { "nixd", "--inlay-hints", "--semantic-tokens" },
            settings = {
                nixd = {
                    nixpkgs = {
                        expr = 'import (builtins.getFlake "/home/arminveres/nix-conf").inputs.nixpkgs',
                    },
                    formatting = { command = { "nixfmt" } },
                    options = {
                        nixos = {
                            expr = '(builtins.getFlake "/home/arminveres/nix-conf").nixosConfigurations.'
                                .. vim.uv.os_gethostname()
                                .. ".options",
                        },
                        home_manager = {
                            expr = '(builtins.getFlake "/home/arminveres/nix-conf").homeConfigurations.'
                                .. "arminveres@"
                                .. vim.uv.os_gethostname()
                                .. ".options",
                        },
                        flake_parts = {
                            expr =
                            'let flake = builtins.getFlake ("/home/arminveres/nix-conf"); in flake.debug.options // flake.currentSystem.options',
                        },
                    },
                },
            },
        })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("pluginsLspConfig", {}),
    callback = function(args)
        -- ========================================================================================
        -- Buffer local mappings.
        -- ========================================================================================
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<bslash>fb", function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)

        vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "]e", function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
            vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "[e", function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
            vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, opts)
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, opts)
        vim.keymap.set("n", "gld", function()
            vim.diagnostic.open_float()
        end, opts)

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

            vim.keymap.set("n", "<Leader>lh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = "Toggle [L]SP Inlay [H]int" })
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
    end,
})

return {
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    config = setup,

    -- allow lazyloading on these events, otherwise it does not load correctly
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    keys = {
        { "<Leader>li", vim.cmd.LspInfo,    desc = "Open [l]sp [i]nfo" },
        {
            "<Leader>ll",
            function()
                local function rotate_log()
                    local log_path = vim.fn.stdpath("state") .. "\\lsp.log"
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

                rotate_log()
                vim.cmd.LspLog()
            end,
            desc = "Open [l]sp [l]og",
        },
        { "<Leader>lr", vim.cmd.LspRestart, desc = "[l]sp [r]estart" },
    },

    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "RRethy/vim-illuminate",
        "Decodetalkers/csharpls-extended-lsp.nvim",
    },
}
