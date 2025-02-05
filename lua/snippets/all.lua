local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local p = require("luasnip.extras").partial

---@return string commentstring of the current filetype
local function get_comment_string()
    -- Get the current buffer's commentstring
    local comment_string = vim.bo.commentstring or ""
    -- Remove the '%s' placeholder and any surrounding whitespace
    local comment_prefix = comment_string:gsub("%%s", ""):gsub("^%s+", ""):gsub("%s+$", "")
    -- If no comment string is found, fall back to `--` as a default
    return comment_prefix ~= "" and comment_prefix or "--"
end

local snippets = {
    s("todo", {
        p(get_comment_string),
        t(" "),
        c(1, { t("TODO"), t("NOTE"), t("WARN"), t("FIXME"), t("BUG"), t("MISC") }),
        t("("),
        c(2, { t("AVE"), t("aver") }),
        t("): "),
    }),
    s("dmy", {
        p(os.date, "%d-%m-%Y"),
    }),
}

ls.add_snippets("all", snippets, { key = "all" })
