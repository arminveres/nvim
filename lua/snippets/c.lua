local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local p = require("luasnip.extras").partial
local fmt = require("luasnip.extras.fmt").fmt

-- TODO(aver):
-- - one could implement a parameter parser and dynamically get the parameter names into the snippet.

local snippets = {
    s("funcdesc", {
        t({ "/// " }),
        c(1, { t({ "@brief ", "" }), t({ " ", "" }) }),
        i(1, "brief description"),
        c(2, { t({ "/// @returns ", "" }), t({ "" }) }),
    }),
    s("doxstar", {
        t("/**"),
        t({ "", " * " }),
        i(1, "Description"),
        t({ "", " * " }),
        t({ "", " * @param " }),
        i(2, "param_name"),
        t({ " " }),
        i(3, "param_description"),
        t({ "", " * @return " }),
        i(4, "return_description"),
        t({ "", " */" }),
    }),
    s("doxtriple", {
        t("/// "),
        i(1, "Description"),
        t({ "", "/// " }),
        t({ "", "/// @param " }),
        i(2, "param_name"),
        t({ " " }),
        i(3, "param_description"),
        t({ "", "/// @return " }),
        i(4, "return_description"),
        t({ "", "///" }),
    }),
    s("diagign", {
        t("#pragma GCC diagnostic push", "\n"),
        t('#pragma GCC diagnostic ignored "'),
        i(1),
        t('"', "\n"),
        t("#pragma GCC diagnostic pop", "\n"),
    }),
    s("inca", fmt("#include <{iNode1}>", { iNode1 = i(1, "example") })),
    s("incq", fmt('#include "{iNode1}"', { iNode1 = i(1, "example") })),
}
ls.add_snippets("c", snippets, { key = "c" })
ls.add_snippets("cpp", snippets, { key = "cpp" })

-- return snippets
