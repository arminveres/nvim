local ls = require("luasnip")
---@type function
local s = ls.snippet
---@type function
local i = ls.insert_node
---@type function
local t = ls.text_node
---@type function
local c = ls.choice_node
local p = require("luasnip.extras").partial

local snippets = {
    s("defmain", {
        t({ "def main():", "" }),
        c(1, { t("\tpass"), t("") }),
        t({
            "",
            "",
            'if __name__=="__main__":',
            "\tmain()",
        }),
    }),
}

ls.add_snippets("python", snippets, { key = "python" })
