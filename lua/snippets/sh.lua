local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local snippets = {
    s("bash", {
        t({ "#!/usr/bin/env bash", "" }),
    }),
    s("bashe", {
        t({ "#!/usr/bin/env bash", "" }),
        t({ "set -e", "" }),
    }),
}

ls.add_snippets("sh", snippets, { key = "sh" })
ls.add_snippets("bash", snippets, { key = "bash" })
ls.add_snippets("all", snippets, { key = "shell-all" })

return snippets
