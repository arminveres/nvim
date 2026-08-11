-- Recursive LSP call hierarchy (incoming/outgoing calls), rendered as a tree
-- in a scratch buffer. Unlike vim.lsp.buf.incoming_calls/outgoing_calls this
-- walks the whole hierarchy (with cycle + depth guards) instead of just one
-- level.

local M = {}

local NS = vim.api.nvim_create_namespace("lsp_callhierarchy")

-- Run fn(item, cb) for every item in parallel and call on_done(results) once
-- all callbacks have fired, preserving input order regardless of completion order.
local function map_async(items, fn, on_done)
    local results = {}
    local pending = #items
    if pending == 0 then
        on_done(results)
        return
    end
    for i, item in ipairs(items) do
        fn(item, function(res)
            results[i] = res
            pending = pending - 1
            if pending == 0 then on_done(results) end
        end)
    end
end

---@param direction "incoming"|"outgoing"
---@param item table CallHierarchyItem
---@param client vim.lsp.Client
---@param depth integer
---@param max_depth integer
---@param visited table<string, boolean>
---@param on_done fun(node: table)
local function walk(direction, item, client, depth, max_depth, visited, on_done)
    local node = { item = item, children = {} }

    local key = table.concat({ item.uri, item.name, item.range.start.line }, "|")

    if depth >= max_depth or visited[key] then
        node.truncated = visited[key] and depth < max_depth
        on_done(node)
        return
    end
    visited[key] = true

    local method = direction == "incoming" and "callHierarchy/incomingCalls"
        or "callHierarchy/outgoingCalls"
    client:request(method, { item = item }, function(err, result)
        if err or not result or #result == 0 then
            on_done(node)
            return
        end

        map_async(result, function(call, cb)
            local child_item = direction == "incoming" and call.from or call.to
            walk(direction, child_item, client, depth + 1, max_depth, visited, cb)
        end, function(children)
            node.children = children
            on_done(node)
        end)
    end, item._bufnr)
end

-- LSP SymbolKind -> (icon, highlight group)
local KIND_INFO = {
    [6] = { icon = "󰊕", hl = "@function.method" }, -- Method
    [9] = { icon = "", hl = "@constructor" }, -- Constructor
    [12] = { icon = "󰊕", hl = "@function" }, -- Function
}
local DEFAULT_KIND = { icon = "", hl = "@function" }

local function render(buf, roots, direction)
    local lines = {}
    local locations = {} -- line (0-idx) -> { uri, range }
    -- highlights[line] = { { col_start, col_end, hl_group }, ... }
    local highlights = {}

    local title = direction == "incoming" and "Incoming calls (callers)"
        or "Outgoing calls (callees)"
    table.insert(lines, title)
    table.insert(lines, "")

    local function add(node, prefix, is_last, is_root)
        local kind = KIND_INFO[node.item.kind] or DEFAULT_KIND
        local connector = is_root and "" or (is_last and "└─ " or "├─ ")
        local file = vim.fn.fnamemodify(vim.uri_to_fname(node.item.uri), ":~:.")
        local lnum = node.item.range.start.line + 1
        local suffix = node.truncated and "  (…)" or ""

        local line = string.format(
            "%s%s%s %s  %s:%d%s",
            prefix,
            connector,
            kind.icon,
            node.item.name,
            file,
            lnum,
            suffix
        )
        table.insert(lines, line)
        local lidx = #lines - 1
        locations[lidx] = { uri = node.item.uri, range = node.item.range }

        local col = #prefix
        local hl = {}
        if connector ~= "" then table.insert(hl, { col, col + #connector, "Comment" }) end
        col = col + #connector
        table.insert(hl, { col, col + #kind.icon, kind.hl })
        col = col + #kind.icon + 1 -- icon + space
        local name_hl = is_root and "@function.builtin" or kind.hl
        table.insert(hl, { col, col + #node.item.name, name_hl })
        col = col + #node.item.name
        table.insert(hl, { col, #line, "Comment" })
        highlights[lidx] = hl

        local child_prefix = prefix .. (is_root and "" or (is_last and "   " or "│  "))
        for i, child in ipairs(node.children) do
            add(child, child_prefix, i == #node.children, false)
        end
    end

    for i, root in ipairs(roots) do
        add(root, "", i == #roots, true)
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false

    vim.api.nvim_buf_clear_namespace(buf, NS, 0, -1)
    vim.api.nvim_buf_set_extmark(buf, NS, 0, 0, { hl_group = "Title", end_col = #lines[1] })
    for lidx, hl in pairs(highlights) do
        for _, seg in ipairs(hl) do
            vim.api.nvim_buf_set_extmark(
                buf,
                NS,
                lidx,
                seg[1],
                { end_col = seg[2], hl_group = seg[3] }
            )
        end
    end

    return locations
end

---@param direction "incoming"|"outgoing"
---@param opts table? { max_depth?: integer }
function M.show(direction, opts)
    opts = opts or {}
    local max_depth = opts.max_depth or 6

    local bufnr = vim.api.nvim_get_current_buf()
    local clients =
        vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/prepareCallHierarchy" })
    local client = clients[1]
    if not client then
        vim.notify("No LSP client supports call hierarchy", vim.log.levels.WARN)
        return
    end

    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:request("textDocument/prepareCallHierarchy", params, function(err, result)
        if err or not result or #result == 0 then
            vim.notify("No call hierarchy item at cursor", vim.log.levels.WARN)
            return
        end

        vim.notify("Resolving call hierarchy…", vim.log.levels.INFO)

        local visited = {}
        for _, item in ipairs(result) do
            item._bufnr = bufnr
        end
        map_async(
            result,
            function(item, cb) walk(direction, item, client, 0, max_depth, visited, cb) end,
            function(roots)
                local buf = vim.api.nvim_create_buf(false, true)
                vim.bo[buf].filetype = "lspcallhierarchy"
                vim.bo[buf].bufhidden = "wipe"
                local locations = render(buf, roots, direction)

                vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    row = 2,
                    col = 4,
                    width = math.max(60, math.floor(vim.o.columns * 0.7)),
                    height = math.max(15, math.floor(vim.o.lines * 0.6)),
                    style = "minimal",
                    border = vim.o.winborder ~= "" and vim.o.winborder or "rounded",
                    title = " Call Hierarchy ",
                    title_pos = "center",
                })

                local function jump()
                    local line = vim.api.nvim_win_get_cursor(0)[1]
                    local loc = locations[line - 1]
                    if not loc then return end
                    vim.api.nvim_win_close(0, true)
                    vim.cmd.edit(vim.uri_to_fname(loc.uri))
                    vim.api.nvim_win_set_cursor(
                        0,
                        { loc.range.start.line + 1, loc.range.start.character }
                    )
                end

                local kopts = { buffer = buf, silent = true, nowait = true }
                vim.keymap.set("n", "<CR>", jump, kopts)
                vim.keymap.set("n", "q", "<cmd>close<cr>", kopts)
                vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", kopts)
            end
        )
    end, bufnr)
end

return M
