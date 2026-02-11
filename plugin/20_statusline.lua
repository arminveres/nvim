--
-- Custom Statusline based on a mixture of GPT4 prompts and reuse of my old config.
-- Features:
--  - Lualine like components, crafted manually.
--  - Only load available components, making this blazingly fast!
--
-- TODO(aver):
-- - consider loading gruvbox colorscheme earlier and linking against those colors or moving the
--   Highlight definitions to the colorscheme.

local set_hi = vim.api.nvim_set_hl
local global_hi_id = 0
local reset = "%#StatusLine#"

set_hi(global_hi_id, "MyStatusLineNormal", { fg = "#282828", bg = "#d75f00", bold = true })
set_hi(global_hi_id, "MyStatusLineVisual", { fg = "#fbf1c7", bg = "#458588", bold = true })
set_hi(global_hi_id, "MyStatusLineInsert", { fg = "#282828", bg = "#98971a", bold = true })
set_hi(global_hi_id, "MyStatusLineTerminal", { fg = "#282828", bg = "#83a598", bold = true })
set_hi(global_hi_id, "MyStatusLineReplace", { fg = "#282828", bg = "#fb4934", bold = true })
-- set_hi(id, "MyStatusLineCommand", { fg = "#282828", bg = "#792329", bold = true })

local function git_changes()
    local status = vim.b.gitsigns_status_dict
    if status and status.head then
        local branch = string.format("%%#GruvboxOrange# %%#Normal#%s ", status.head)
        local added = string.format("%%#GitSignsAdd# +%d", status.added or 0)
        local changed = string.format("%%#GitSignsChange# ~%d", status.changed or 0)
        local deleted = string.format("%%#GitSignsDelete# -%d", status.removed or 0)

        return branch .. "|" .. added .. changed .. deleted .. reset
    end
    -- Return a placeholder or empty string if gitsigns data is not available
    return ""
end

local function get_diagnostics_info()
    local counts = {
        errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
        warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
        hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
        info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
    }

    local result = {}
    if counts.errors > 0 then
        table.insert(result, string.format("%%#DiagnosticError#  %d", counts.errors))
    end
    if counts.warnings > 0 then
        table.insert(result, string.format("%%#DiagnosticWarn#  %d", counts.warnings))
    end
    if counts.hints > 0 then
        table.insert(result, string.format("%%#DiagnosticHint#  %d", counts.hints))
    end
    if counts.info > 0 then
        table.insert(result, string.format("%%#DiagnosticInfo# 󰋼 %d", counts.info))
    end

    if #result > 0 then return " |" .. table.concat(result, " ") .. reset end
    return ""
end

local function get_mode()
    local mode_map = {
        ["n"] = "%%#MyStatusLineNormal# NORMAL ",
        ["no"] = "%%#MyStatusLineNormal# N·Operator Pending ",
        ["v"] = "%%#MyStatusLineVisual# VISUAL ",
        ["V"] = "%%#MyStatusLineVisual# V·Line ",
        [""] = "%%#MyStatusLineVisual# V·Block ",
        ["s"] = "SELECT",
        ["S"] = "S·Line",
        [""] = "S·Block",
        ["i"] = "%%#MyStatusLineInsert# INSERT ",
        ["ic"] = "%%#MyStatusLineInsert# INSERT ",
        ["R"] = "%%#MyStatusLineReplace# REPLACE ",
        ["Rv"] = "%%#MyStatusLineVisual# V·Replace ",
        ["c"] = "%%#MyStatusLineTerminal# COMMAND ",
        ["cv"] = "Vim Ex",
        ["ce"] = "Ex",
        ["r"] = "Prompt",
        ["rm"] = "More",
        ["r?"] = "Confirm",
        ["!"] = "Shell",
        ["t"] = "%%#MyStatusLineTerminal# TERMINAL ",
        ["nt"] = "%%#MyStatusLineTerminal# TERMINAL ",
    }

    local mode = mode_map[vim.api.nvim_get_mode().mode] or "Unknown"
    -- return mode .. " " .. reset
    -- return string.format(mode) .. reset .. " "

    local recording = vim.fn.reg_recording()
    if recording ~= "" then mode = mode .. "(REC @" .. recording .. ") " end
    return string.format(mode) .. reset .. " "
end

local function get_lsps()
    local names = {}
    for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
    end
    if #names > 0 then return " [" .. table.concat(names, " ") .. "] |" end
    return ""
end

local function get_cwd()
    local cwd = vim.uv.cwd()
    if cwd then
        local dirname = vim.fn.fnamemodify(cwd, ":t")
        return dirname .. " > "
    end
    return ""
end

local statusline_cache = ""

local function update_statusline()
    local align = "%=" -- Single align: left-right. Two aligns: 3 sections.
    local file_name = "%f"
    local modified = "%m"
    local fileencoding = "%{&fileencoding?&fileencoding:&encoding}"
    local fileformat = "[%{&fileformat}]"
    local filetype = "  %y"
    local percentage = "%p%%"
    local linecol = " %l:%c"

    local new_statusline = reset -- left segment
        .. get_mode()
        .. git_changes()
        .. get_diagnostics_info()
        .. align -- middle segment
        .. get_cwd()
        .. file_name
        .. modified
        .. align -- right segment
        .. get_lsps()
        .. filetype
        .. " | "
        .. fileencoding
        .. " "
        .. fileformat
        .. " | "
        .. percentage
        .. linecol

    -- use a cached update, possibly improving performance (untested)
    if statusline_cache ~= new_statusline then
        statusline_cache = new_statusline
        vim.o.statusline = new_statusline
        vim.cmd("redrawstatus")
    end
end

vim.api.nvim_create_autocmd({
    "ModeChanged",
    "CmdlineEnter",
    "BufEnter",
    "BufWritePost",
    "CursorHold",
    "CursorMoved",
    "InsertEnter",
    "TextChanged",
    "DiagnosticChanged", -- ensure diagnostics trigger an update, especially in InsertMode
}, {
    callback = function() vim.schedule(update_statusline) end,
})
