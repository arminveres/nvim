local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local p = require("luasnip.extras").partial

---@return string commentstring of the current filetype
local function get_comment_string()
    if vim.treesitter.get_node():type():match("comment*") then return "" end
    -- Get the current buffer's commentstring
    local comment_string = vim.bo.commentstring or ""
    -- Remove the '%s' placeholder and any surrounding whitespace
    local comment_prefix = comment_string:gsub("%%s", ""):gsub("^%s+", ""):gsub("%s+$", "")
    -- If no comment string is found, fall back to `--` as a default
    return comment_prefix ~= "" and comment_prefix or "--"
end

---@return string Space if needed, empty otherwise
local function conditional_space()
    local col_pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    if col_pos > 1 and line:sub(col_pos - 1, col_pos + 1):match(" ") then
        -- still return a space if we are not inside a comment, otherwise on indents it will think
        -- we have enoug space
        if not vim.treesitter.get_node():type():match("comment*") then return " " end
        return ""
    end
    return " "
end

local snippets = {

    s("todo", {
        p(get_comment_string),
        p(conditional_space),
        c(1, {
            t("TODO"),
            t("NOTE"),
            t("WARN"),
            t("BUG"),
            -- t("FIXME"),
            -- t("MISC")
        }),
        t("("),
        c(2, { t("AVE"), t("aver") }),
        t("): "),
        c(3, {
            p(function()
                -- add space after the date
                return os.date("%d-%m-%Y") .. " "
            end),
            t("Linux - "),
            t(""),
        }),
    }),

    s("dmy", { p(os.date, "%d-%m-%Y"), }),
}

ls.add_snippets("all", snippets, { key = "all" })
