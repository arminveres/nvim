local aucmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup
local merge_desc = require("core.utils").merge_desc

aucmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
})

aucmd("BufWritePre", {
    group = create_augroup("AutoCreateDir", { clear = true }),
    callback = function(event)
        local file = event.match
        -- Ignore creation of oil:// directories, which get created on each save in an Oil.nvim buffer.
        if file:match("^oil://") then return end
        local dir = vim.fn.fnamemodify(file, ":p:h")
        if vim.fn.isdirectory(dir) == 1 then return end
        vim.fn.mkdir(dir, "p")
    end,
})

aucmd({ "BufEnter", LspAttach }, {
    group = create_augroup("CustomRooter", { clear = true }),
    callback = function(ev)
        -- vim.notify(vim.inspect(ev))
        local patterns = {
            "compile_commands.json",
            ".clangd",
            ".clang-format",
            ".clang-tidy",
            ".git",
            "Makefile",
            "README.md",
            "readme.md",
            -- "CMakeLists.txt"
        }
        local root_dir = nil
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
        local clients = vim.lsp.get_clients({ bufnr = ev.buf })

        -- if next(clients) ~= nil then
        for _, client in ipairs(clients) do
            if client.name ~= "null-ls" then
                ---@diagnostic disable-next-line: undefined-field
                local filetypes = client.config.filetypes
                -- look for first root dir of a client that matches the current buffer and its
                -- file type
                -- if filetypes == buf_ft and vim.fn.index(filetypes, buf_ft) ~= -1 then
                if vim.fn.index(filetypes, buf_ft) ~= -1 then
                    root_dir = client.config.root_dir
                    -- vim.notify("lsp: " .. vim.inspect(client), vim.log.levels.DEBUG)
                    -- vim.notify("root dir lsp: " .. root_dir, vim.log.levels.DEBUG)
                    break
                end
            end
        end
        -- end

        -- try to get a root dir by a marker
        if not root_dir then root_dir = vim.fs.root(ev.buf, patterns) end
        -- early return on failure or no change
        if not root_dir then return end
        -- TODO(aver): 27-03-2025 try to find a cleaner call to this
        local pwd = vim.fs.normalize(vim.uv.cwd())
        -- don't update on same dir
        if pwd == root_dir then return end

        vim.notify(
            "ROOTER: Changing from '" .. pwd .. "' to' " .. root_dir .. "'",
            vim.log.levels.INFO
        )
        -- :h nvim_parse_cmd()
        vim.cmd.tcd({ args = { root_dir }, mods = { silent = true } })
    end,
})

aucmd("LspAttach", {
    group = create_augroup("pluginsLspConfig", {}),
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
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, merge_desc(opts, "[g]o to [d]efinition"))
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set(
            "n",
            ",bf",
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
        -- if client.server_capabilities.documentFormattingProvider then
        --     vim.api.nvim_create_autocmd({ "BufWrite" }, {
        --         group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
        --         callback = function()
        --             -- WARN: use false, otherwise not possible to save
        --             vim.lsp.buf.format({ async = false })
        --         end,
        --     })
        -- end

        vim.lsp.log.set_format_func(vim.inspect)

        vim.diagnostic.config({ virtual_text = false })

        -- NOTE(aver): ensure lsp logs don't get too large
        -- rotate_log()
    end,
})

-- aucmd("BufLeave", {
--     group = create_augroup("lspLogCleaner", { clear = true }),
--     callback = function()
--         local log_path = vim.fn.stdpath("state") .. "/lsp.log"
--         local backup_path = log_path .. ".old"

--         local stat = vim.loop.fs_stat(log_path)
--         if stat and stat.size > 1024 * 1024 then -- Limit to 1 MB
--             -- Rename the current log file
--             local succ, msg = os.rename(log_path, backup_path)
--             -- local succ, msg = os.remove(log_path)
--             if not succ then
--                 ---@diagnostic disable-next-line: param-type-mismatch
--                 vim.notify(msg, vim.log.levels.ERROR)
--                 return
--             end
--             vim.notify("Neovim log rotated", vim.log.levels.INFO)
--         end
--     end,
-- })
