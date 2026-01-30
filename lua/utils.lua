local M = {}

---brief Merge two tables through vim api
function M.merge(table1, table2) return vim.tbl_deep_extend("force", table1, table2) end

---Merge a description into the options
function M.merge_desc(opts, description) return M.merge(opts, { desc = description }) end

---Change the cwd of the current tab to the root of the open project, if possible.
---@param bufnr number Buffer ID
---@param select_lsp_only boolean skip marker based change.
function M.root_project(bufnr, select_lsp_only)
    local patterns = {
        ".clangd",
        "compile_commands.json",
        ".clang-format",
        ".clang-tidy",
        ".git",
        "Makefile",
        "README.md",
        "readme.md",
        -- "CMakeLists.txt"
    }
    local ignored_lsps = {
        "null-ls",
    }
    local root_dir = nil
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    for _, client in ipairs(clients) do
        if vim.fn.index(ignored_lsps, client.name) == -1 then -- only if not found
            ---@diagnostic disable-next-line: undefined-field
            local filetypes = client.config.filetypes or {}
            -- look for first root dir of a client that matches the current buffer and its
            -- file type
            if vim.fn.index(filetypes, buf_ft) ~= -1 then
                root_dir = client.config.root_dir
                break
            end
        end
    end

    if not root_dir then
        if select_lsp_only then return end
        -- try to get a root dir by a marker
        root_dir = vim.fs.root(bufnr, patterns)
    end
    if not root_dir then
        -- early return on failure or no change
        return
    end
    -- TODO(aver): 27-03-2025 try to find a cleaner call to this
    ---@diagnostic disable-next-line: param-type-mismatch
    local pwd = vim.fs.normalize(vim.uv.cwd())
    -- don't update on same dir
    if pwd == root_dir then return end

    vim.notify("ROOTER: Changing from '" .. pwd .. "' to' " .. root_dir .. "'", vim.log.levels.INFO)
    -- :h nvim_parse_cmd()
    vim.cmd.tcd({ args = { root_dir }, mods = { silent = true } })
end

return M
