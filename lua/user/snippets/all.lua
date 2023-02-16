local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local p = require("luasnip.extras").partial

local function get_comment_string()
  local f = require("ts_context_commentstring.internal").calculate_commentstring()
  print(f)
  local splitted = vim.split(f, "%s", {})
  if #splitted == 0 then
    return ""
  end
  return splitted[1]
end

local snippets = {
  s("todo", {
    -- p(get_comment_string), -- BUG: does not work :( returns nil
    -- t(" "),
    c(1, { t("TODO"), t("FIXME"), t("NOTE"), t("BUG"), t("MISC") }),
    t(": (aver) "),
  }),
  s("dmy", {
    p(os.date, "%d-%m-%Y"),
  }),
}

return snippets
