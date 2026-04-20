--
-- Custom Statusline
--
-- Features:
--  - Lualine like components, crafted manually.
--  - Only load available components, making this blazingly fast!
--  - Highlight mode in left and right component
-- Caveats:
-- - Depends on gruvbox as colorscheme, as its palette is heavily used.
--
-- Sources:
-- - LLM
-- - https://jacobnscott.com/posts/nvim-statusline/

local hl = require("utils").hl
local reset = "%#StatusLine#"
local warn = "%#WarningMsg#"
local plt = require("gruvbox").palette

-- Compile and apply our custom highlights
local base = hl("StatusLine")
for group, opts in pairs({
    ModeNormal = { fg = base.bg, bg = plt.neutral_orange, bold = true },
    ModePending = { fg = base.bg, bg = hl("Comment").fg, bold = true },
    ModeVisual = { fg = base.bg, bg = plt.bright_blue, bold = true },
    ModeInsert = { fg = base.bg, bg = plt.neutral_green, bold = true },
    ModeCommand = { fg = base.bg, bg = plt.neutral_red, bold = true },
    ModeReplace = { fg = base.bg, bg = plt.bright_red, bold = true },
    Bold = { fg = base.fg, bg = base.bg, bold = true },
    Dim = { fg = hl("LineNr").fg, bg = base.bg },
}) do
    group = "StatusLine" .. group
    vim.api.nvim_set_hl(0, group, opts)
    opts.fg, opts.bg = opts.bg, opts.fg
    vim.api.nvim_set_hl(0, group .. "Inverted", opts)
end

local function git_changes()
    local status = vim.b.gitsigns_status_dict
    local result = ""
    if status and status.head then
        local branch = string.format("%%#GruvboxOrange# %s%s ", reset, status.head)
        local changes = ""

        if status.added and status.added > 0 then
            local added = string.format("%%#GitSignsAdd# +%d", status.added)
            changes = changes .. added
        end

        if status.changed and status.changed > 0 then
            local changed = string.format("%%#GitSignsChange# ~%d", status.changed)
            changes = changes .. changed
        end

        if status.removed and status.removed > 0 then
            local deleted = string.format("%%#GitSignsDelete# -%d", status.removed)
            changes = changes .. deleted
        end

        result = branch .. reset
        if changes ~= "" then result = result .. "|" .. changes .. reset end
    end
    -- Return a placeholder or empty string if gitsigns data is not available
    return result
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

-- Note: termcodes \19 and \22 are ^S and ^V
local mode_settings = {
    ["n"] = { name = "NORMAL", hl = "Normal" },
    ["no"] = { name = "OP-PENDING", hl = "Pending" },
    ["nov"] = { name = "OP-PENDING", hl = "Pending" },
    ["noV"] = { name = "OP-PENDING", hl = "Pending" },
    ["no\22"] = { name = "OP-PENDING", hl = "Pending" },
    ["niI"] = { name = "NORMAL", hl = "Normal" },
    ["niR"] = { name = "NORMAL", hl = "Normal" },
    ["niV"] = { name = "NORMAL", hl = "Normal" },
    ["nt"] = { name = "NORMAL", hl = "Normal" },
    ["ntT"] = { name = "NORMAL", hl = "Normal" },
    ["v"] = { name = "VISUAL", hl = "Visual" },
    ["vs"] = { name = "VISUAL", hl = "Visual" },
    ["V"] = { name = "V-LINE", hl = "Visual" },
    ["Vs"] = { name = "V-LINE", hl = "Visual" },
    ["\22"] = { name = "V-BLOCK", hl = "Visual" },
    ["\22s"] = { name = "V-BLOCK", hl = "Visual" },
    ["s"] = { name = "SELECT", hl = "Insert" },
    ["S"] = { name = "S-LINE", hl = "Normal" },
    ["\19"] = { name = "S-BLOCK", hl = "Normal" },
    ["i"] = { name = "INSERT", hl = "Insert" },
    ["ic"] = { name = "INSERT", hl = "Insert" },
    ["ix"] = { name = "INSERT", hl = "Insert" },
    ["R"] = { name = "REPLACE", hl = "Replace" },
    ["Rc"] = { name = "REPLACE", hl = "Replace" },
    ["Rx"] = { name = "REPLACE", hl = "Replace" },
    ["Rv"] = { name = "V-REPLACE", hl = "Replace" },
    ["Rvc"] = { name = "V-REPLACE", hl = "Replace" },
    ["Rvx"] = { name = "V-REPLACE", hl = "Replace" },
    ["c"] = { name = "COMMAND", hl = "Command" },
    ["cv"] = { name = "EX", hl = "Command" },
    ["ce"] = { name = "EX", hl = "Command" },
    ["r"] = { name = "REPLACE", hl = "Normal" },
    ["rm"] = { name = "MORE", hl = "Normal" },
    ["r?"] = { name = "CONFIRM", hl = "Normal" },
    ["!"] = { name = "SHELL", hl = "Normal" },
    ["t"] = { name = "TERMINAL", hl = "Command" },
}

local function get_mode_hl(mode)
    return string.format("%%#StatuslineMode%s#", mode.hl)
end

local function get_mode_comp(mode)
    return string.format("%%#StatuslineMode%s# %s %s ", mode.hl, mode.name, reset)
    -- return table.concat({ "%#StatuslineMode" .. mode.hl .. "Inverted" .. "#", "%#StatuslineMode" .. mode.hl .. "# " .. mode.name .. " " .. reset, "%#StatuslineMode" .. mode.hl .. "Inverted" .. "#", })
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

local function get_macro_state()
    local r = vim.fn.reg_recording()
    local e = vim.fn.reg_executing()
    local rec = (r ~= "" and ("recording @" .. r)) or (e ~= "" and ("playing @" .. e)) or ""
    return " " .. warn .. rec .. reset .. " "
end

local statusline_cache = ""

--- Main render function
function _G.MyStatusline()
    local align = "%=" -- Single align: left-right. Two aligns: 3 sections.
    local file_name = "%<%t"
    local modified = "%m"
    local fileencoding = "%{&fileencoding?&fileencoding:&encoding}"
    local fileformat = "[%{&fileformat}]"
    local filetype = "  %y"
    local percentage = "%p%%"
    local linecol = " %l:%c"
    local mode = mode_settings[vim.api.nvim_get_mode().mode]

    local new_statusline = reset -- left segment
        .. get_mode_comp(mode)
        .. git_changes()
        .. get_diagnostics_info()
        .. align -- middle segment
        .. get_cwd()
        .. file_name
        .. modified
        .. align -- right segment
        .. get_macro_state()
        .. get_lsps()
        .. filetype
        .. " | "
        .. fileencoding
        .. " "
        .. fileformat
        .. " "
        .. get_mode_hl(mode)
        .. " "
        .. percentage
        .. linecol
        .. " "
        .. reset

    -- use a cached update, possibly improving performance (untested)
    if statusline_cache ~= new_statusline then statusline_cache = new_statusline end
    return statusline_cache
end

vim.o.statusline = "%!v:lua.MyStatusline()"
