--[[
-- Custom Statusline based on a mixture of GPT4 prompts and reuse of my old config.
--]]

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
    local diagnostics = vim.diagnostic.get(0) -- 0 for the current buffer
    local counts = { errors = 0, warnings = 0, hints = 0, info = 0 }

    for _, diag in ipairs(diagnostics) do
        if diag.severity == vim.diagnostic.severity.ERROR then
            counts.errors = counts.errors + 1
        elseif diag.severity == vim.diagnostic.severity.WARN then
            counts.warnings = counts.warnings + 1
        elseif diag.severity == vim.diagnostic.severity.HINT then
            counts.hints = counts.hints + 1
        elseif diag.severity == vim.diagnostic.severity.INFO then
            counts.info = counts.info + 1
        end
    end

    local errors = string.format("%%#DiagnosticError#  %d", counts.errors)
    local warnings = string.format("%%#DiagnosticWarn#  %d", counts.warnings)
    local hints = string.format("%%#DiagnosticHint#  %d", counts.hints)
    local infos = string.format("%%#DiagnosticInfo# 󰋼 %d", counts.info)

    local return_str = ""
    if counts.errors > 0 then
        return_str = return_str .. errors
    elseif counts.warnings > 0 then
        return_str = return_str .. warnings
    elseif counts.hints > 0 then
        return_str = return_str .. hints
    elseif counts.info > 0 then
        return_str = return_str .. infos
    end

    if return_str ~= "" then
        return return_str .. reset .. " | "
    else
        return return_str
    end
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

local function statusline()
    local file_name = "%f"
    local modified = "%m"
    local align_right = "%="
    local fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
    local fileformat = " [%{&fileformat}]"
    local filetype = " %y"
    local percentage = " %p%%"
    local linecol = " %l:%c"

    return string.format(
        "%s%s%s%s%s%s%s%s%s%s%s%s%s",
        reset,
        get_mode(),
        git_changes(),
        get_diagnostics_info(),
        file_name,
        modified,
        align_right,
        get_lsps(),
        filetype,
        fileencoding,
        fileformat,
        percentage,
        linecol
    )
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
    -- "InsertChange",
    -- "InsertCharPre",
}, {
    callback = function()
        vim.o.statusline = statusline()
    end,
})
