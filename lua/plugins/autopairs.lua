return {
    "windwp/nvim-autopairs", -- Autopairs {}, [], () etc
    event = "VeryLazy",
    opts = {
        -- local Rule = require("nvim-autopairs.rule")
        -- npairs.add_rule(Rule("<", ">")) -- finally add a tag rule
        fast_wrap = {
            map = "<M-e>",
            chars = { "{", "[", "(", '"', "'", "<" },
            pattern = [=[[%'%"%>%]%)%}%;%,]]=],
        },
        check_ts = true,
        map_cr = false,
    },
    dependencies = "hrsh7th/nvim-cmp",
}
