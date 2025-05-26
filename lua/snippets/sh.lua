local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local p = require("luasnip.extras").partial

local snippets = {
    -- s("bash", { t({ "#!/usr/bin/env bash", "" }), }),
    s("bashe", {
        t({ "#!/usr/bin/env bash", "#", "# " }),
        i(1),
        t({ "", "set -euo pipefail", "" }),
    }),
}

ls.add_snippets("sh", snippets, { key = "sh" })
ls.add_snippets("bash", snippets, { key = "bash" })
ls.add_snippets("", snippets, { key = "shell-all" })

return snippets
