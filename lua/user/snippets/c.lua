local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local p = require("luasnip.extras").partial

local snippets = {
  s("funcdesc", {
    t("/**"),
    i(1),
    c(1, { t("@brief ") }),
    i(2),
    c(2, { t("@returns ") }),
    i(3),
    t("*/"),
  }),
  s("diagign", {
    t("#pragma GCC diagnostic push", "\n"),
    t("#pragma GCC diagnostic ignored \""),
    i(1),
    t("\"", "\n"),
    t("#pragma GCC diagnostic pop", "\n"),
  })
}

return snippets
