local M = {}

local STORAGE_PATH = vim.fn.stdpath("data") .. "/bookmarks.json"
local MAX_SLOTS = 4

-- Use Neovim's tab-local cwd (kept updated by root_project in autocmds)
local function project_key()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("[/\\]$", "")
end

local function load_all()
    local f = io.open(STORAGE_PATH, "r")
    if not f then return {} end
    local raw = f:read("*a")
    f:close()
    if raw == "" then return {} end
    local ok, data = pcall(vim.json.decode, raw)
    return (ok and type(data) == "table") and data or {}
end

local function save_all(data)
    local f = io.open(STORAGE_PATH, "w")
    if not f then
        vim.notify("Bookmarks: cannot write " .. STORAGE_PATH, vim.log.levels.ERROR)
        return
    end
    f:write(vim.json.encode(data))
    f:close()
end

local function get_slots()
    local all = load_all()
    local raw = all[project_key()]
    if type(raw) ~= "table" then return {} end
    local slots = {}
    for i = 1, MAX_SLOTS do
        local v = raw[i]
        if type(v) == "string" then slots[i] = v end
    end
    return slots
end

local function set_slots(slots)
    local all = load_all()
    -- Always write a fixed-length array so null placeholders round-trip through JSON
    local arr = {}
    for i = 1, MAX_SLOTS do
        arr[i] = slots[i] or vim.NIL
    end
    all[project_key()] = arr
    save_all(all)
end

-- ─── Public API ────────────────────────────────────────────────────────────

function M.add()
    local file = vim.fn.expand("%:p")
    if file == "" then return end
    local slots = get_slots()
    for i = 1, MAX_SLOTS do
        if slots[i] == file then
            vim.notify("Bookmarks: already in slot " .. i, vim.log.levels.INFO)
            return
        end
    end
    for i = 1, MAX_SLOTS do
        if not slots[i] then
            slots[i] = file
            set_slots(slots)
            vim.notify("Bookmarks: added to slot " .. i, vim.log.levels.INFO)
            return
        end
    end
    vim.notify("Bookmarks: all slots full — remove one first", vim.log.levels.WARN)
end

function M.remove_current()
    local file = vim.fn.expand("%:p")
    local slots = get_slots()
    for i = 1, MAX_SLOTS do
        if slots[i] == file then
            slots[i] = nil
            set_slots(slots)
            vim.notify("Bookmarks: removed from slot " .. i, vim.log.levels.INFO)
            return
        end
    end
    vim.notify("Bookmarks: current file is not bookmarked", vim.log.levels.WARN)
end

function M.goto_slot(n)
    local slots = get_slots()
    local file = slots[n]
    if not file then
        vim.notify("Bookmarks: slot " .. n .. " is empty", vim.log.levels.WARN)
        return
    end
    if vim.fn.filereadable(file) == 0 then
        vim.notify("Bookmarks: file no longer readable: " .. file, vim.log.levels.WARN)
        return
    end
    vim.cmd.edit(file)
end

-- ─── Menu ──────────────────────────────────────────────────────────────────

local menu_win = nil
local menu_buf = nil
local ns = vim.api.nvim_create_namespace("bookmarks_menu")

local function display_name(path)
    local cwd = vim.fn.getcwd()
    local sep = package.config:sub(1, 1)
    local prefix = cwd:gsub("[/\\]$", "") .. sep
    if path:sub(1, #prefix) == prefix then return path:sub(#prefix + 1) end
    return vim.fn.fnamemodify(path, ":~")
end

local function build_lines(slots)
    local lines = {}
    for i = 1, MAX_SLOTS do
        if slots[i] then
            lines[i] = string.format(" %d  %s", i, display_name(slots[i]))
        else
            lines[i] = string.format(" %d  —", i)
        end
    end
    return lines
end

function M.toggle_menu()
    -- Close if already open
    if menu_win and vim.api.nvim_win_is_valid(menu_win) then
        vim.api.nvim_win_close(menu_win, true)
        menu_win = nil
        menu_buf = nil
        return
    end

    -- Capture before the window steals focus and changes the "current" buffer
    local current_file = vim.fn.expand("%:p")

    local slots = get_slots()
    local buf = vim.api.nvim_create_buf(false, true)
    menu_buf = buf
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].modifiable = false

    local width = 64
    local height = MAX_SLOTS
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2) - 1,
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Bookmarks ",
        title_pos = "center",
        footer = " <CR>/<1-4> jump · d delete · q close ",
        footer_pos = "center",
    })
    menu_win = win

    local function refresh()
        slots = get_slots()
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, build_lines(slots))
        vim.bo[buf].modifiable = false
        -- Highlight the slot that holds the file that was open when the menu launched
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        for i = 1, MAX_SLOTS do
            if slots[i] == current_file then
                vim.api.nvim_buf_add_highlight(buf, ns, "PmenuSel", i - 1, 0, -1)
                break
            end
        end
    end

    refresh()

    -- Place cursor on the current file's slot (if bookmarked)
    for i = 1, MAX_SLOTS do
        if slots[i] == current_file then
            vim.api.nvim_win_set_cursor(win, { i, 0 })
            break
        end
    end

    local function close()
        local w = menu_win
        menu_win = nil
        menu_buf = nil
        if w and vim.api.nvim_win_is_valid(w) then vim.api.nvim_win_close(w, true) end
    end

    local function jump_row(row_idx)
        local file = slots[row_idx]
        close()
        if not file then return end
        if vim.fn.filereadable(file) == 0 then
            vim.notify("Bookmarks: file no longer readable: " .. file, vim.log.levels.WARN)
            return
        end
        vim.cmd.edit(file)
    end

    local function delete_row(row_idx)
        if slots[row_idx] then
            slots[row_idx] = nil
            set_slots(slots)
            refresh()
        end
    end

    local mo = { buffer = buf, nowait = true, silent = true }
    vim.keymap.set("n", "q", close, mo)
    vim.keymap.set("n", "<Esc>", close, mo)
    vim.keymap.set("n", "<CR>", function()
        jump_row(vim.api.nvim_win_get_cursor(win)[1])
    end, mo)
    vim.keymap.set("n", "d", function()
        delete_row(vim.api.nvim_win_get_cursor(win)[1])
    end, mo)
    for i = 1, MAX_SLOTS do
        vim.keymap.set("n", tostring(i), function() jump_row(i) end, mo)
    end

    -- Close when focus leaves the menu window
    vim.api.nvim_create_autocmd("WinLeave", {
        buffer = buf,
        once = true,
        callback = close,
    })
end

return M
