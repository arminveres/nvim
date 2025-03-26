local aucmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

aucmd({ "TextYankPost" }, {
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

aucmd({ "BufEnter", "WinEnter" }, {
    group = create_augroup("CustomRooter", { clear = true }),
    callback = function(ev)
        -- TODO(aver): 17/03/2025 add lsp rooting, remove from lualine callback
        -- vim.notify(vim.inspect(ev))
        local patterns = {
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
            ---@diagnostic disable-next-line: undefined-field
            local filetypes = client.config.filetypes
            -- look for first root dir of a client that matches the current buffer and its
            -- file type
            if filetypes == buf_ft and vim.fn.index(filetypes, buf_ft) ~= -1 then
                root_dir = client.config.root_dir
                break
            end
        end
        -- end

        if not root_dir then root_dir = vim.fs.root(ev.buf, patterns) end

        if root_dir then
            vim.notify("ROOTER: updating to " .. root_dir, vim.log.levels.INFO)
            -- :h nvim_parse_cmd()
            vim.cmd.tcd({ args = { root_dir }, mods = { silent = true } })
        end
    end,
})
