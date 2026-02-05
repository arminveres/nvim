--
-- Custom Statusline based on a mixture of GPT4 prompts and reuse of my old config.
--

local reset = "%#Normal#"

-- local id = vim.api.nvim_create_namespace("MyStatusLine")
local id = 0
vim.api.nvim_set_hl(id, "MyStatusLineNormal", { fg = "#282828", bg = "#d75f00", bold = true })
vim.api.nvim_set_hl(id, "MyStatusLineVisual", { fg = "#fbf1c7", bg = "#458588", bold = true })
vim.api.nvim_set_hl(id, "MyStatusLineInsert", { fg = "#282828", bg = "#98971a", bold = true })
vim.api.nvim_set_hl(id, "MyStatusLineTerminal", { fg = "#282828", bg = "#83a598", bold = true })
vim.api.nvim_set_hl(id, "MyStatusLineCommand", { fg = "#282828", bg = "#792329", bold = true })

local function git_changes()
    local status = vim.b.gitsigns_status_dict
    if status and status.head then
        local branch = string.format("%%#GruvboxOrange# %%#Normal#%s ", status.head)
        local added = string.format("%%#GitSignsAdd# +%d", status.added or 0)
        local changed = string.format("%%#GitSignsChange# ~%d", status.changed or 0)
        local deleted = string.format("%%#GitSignsDelete# -%d", status.removed or 0)

        return branch .. "|" .. added .. changed .. deleted .. reset .. " | "
    else
        -- Return a placeholder or empty string if gitsigns data is not available
        return ""
    end
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

    return #result > 0 and table.concat(result, " ") .. reset .. " | " or ""
end

local function get_mode()
    local mode_map = {
        ["n"] = "%%#MyStatusLineNormal# NORMAL ",
        ["no"] = "N·Operator Pending",
        ["v"] = "%%#MyStatusLineVisual# VISUAL ",
        ["V"] = "%%#MyStatusLineVisual# V·Line ",
        [""] = "%%#MyStatusLineVisual# V·Block ",
        ["s"] = "SELECT",
        ["S"] = "S·Line",
        [""] = "S·Block",
        ["i"] = "%%#MyStatusLineInsert# INSERT ",
        ["ic"] = "%%#MyStatusLineInsert# INSERT ",
        ["R"] = "Replace",
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
    return string.format(mode) .. reset .. " "
end

local function get_lsps()
    local names = {}
    for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "]"
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
    -- TODO(aver): make it work in insert mode, consider using vim.schedule for performance reasons,
    -- not to overload in insert mode
    -- "InsertChange",
    -- "InsertCharPre",
}, {
    callback = function()
        local file_name = "%f"
        local modified = "%m"
        local align_right = "%="
        local fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
        local fileformat = " [%{&fileformat}]"
        local filetype = " %y"
        local percentage = " %p%%"
        local linecol = " %l:%c"

        vim.o.statusline = reset
            .. get_mode()
            .. git_changes()
            .. get_diagnostics_info()
            .. file_name
            .. modified
            .. align_right
            .. get_lsps()
            .. filetype
            .. fileencoding
            .. fileformat
            .. percentage
            .. linecol
    end,
})
