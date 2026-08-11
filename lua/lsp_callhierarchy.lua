-- Recursive LSP call hierarchy (incoming/outgoing calls), rendered as a tree
-- in a scratch buffer. Unlike vim.lsp.buf.incoming_calls/outgoing_calls this
-- walks the whole hierarchy (with cycle + depth guards) instead of just one
-- level.

local M = {}

local NS = vim.api.nvim_create_namespace("lsp_callhierarchy")

---@param direction "incoming"|"outgoing"
---@param item table CallHierarchyItem
---@param client vim.lsp.Client
---@param depth integer
---@param max_depth integer
---@param visited table<string, boolean>
---@param on_done fun(node: table)
local function walk(direction, item, client, depth, max_depth, visited, on_done)
    local node = { item = item, children = {} }

    local key = table.concat({
        item.uri or (item.name .. tostring(item.range and item.range.start.line)),
        item.name,
        item.range and item.range.start.line or 0,
    }, "|")

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

        local pending = #result
        for _, call in ipairs(result) do
            local child_item = direction == "incoming" and call.from or call.to
            walk(direction, child_item, client, depth + 1, max_depth, visited, function(child_node)
                table.insert(node.children, child_node)
                pending = pending - 1
                if pending == 0 then on_done(node) end
            end)
        end
    end, item._bufnr)
end

local KIND_ICON = {
    [12] = "", -- Function
    [6] = "", -- Method
    [9] = "", -- Constructor
}

local function render(buf, roots, direction)
    local lines = {}
    local locations = {} -- line (0-idx) -> { uri, range }

    local title = direction == "incoming" and "Incoming calls (callers)"
        or "Outgoing calls (callees)"
    table.insert(lines, title)
    table.insert(lines, "")

    local function add(node, prefix, is_last, is_root)
        local icon = KIND_ICON[node.item.kind] or ""
        local connector = is_root and "" or (is_last and "└─ " or "├─ ")
        local file = vim.fn.fnamemodify(vim.uri_to_fname(node.item.uri), ":~:.")
        local lnum = node.item.range.start.line + 1
        local suffix = node.truncated and "  (…)" or ""
        table.insert(
            lines,
            string.format(
                "%s%s%s %s  %s:%d%s",
                prefix,
                connector,
                icon,
                node.item.name,
                file,
                lnum,
                suffix
            )
        )
        locations[#lines - 1] = { uri = node.item.uri, range = node.item.range }

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

    vim.api.nvim_buf_set_extmark(buf, NS, 0, 0, { hl_group = "Title", end_col = #lines[1] })

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
        local roots = {}
        local pending = #result
        for _, item in ipairs(result) do
            item._bufnr = bufnr
            walk(direction, item, client, 0, max_depth, visited, function(node)
                table.insert(roots, node)
                pending = pending - 1
                if pending == 0 then
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
                        border = "rounded",
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
            end)
        end
    end, bufnr)
end

return M
