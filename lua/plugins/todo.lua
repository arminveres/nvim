return {
    "folke/todo-comments.nvim",
    lazy = false,
    keys = {
        {
            "]t",
            function()
                require("todo-comments").jump_next()
            end,
            desc = "Next TODO comment",
        },
        {
            "[t",
            function()
                require("todo-comments").jump_prev()
            end,
            desc = "Previous TODO comment",
        },
    },
    opts = {
        search = { pattern = [[\b(KEYWORDS).*:?]] },
        highlight = {
            pattern = [[.*<(KEYWORDS).*:]],
            keyword = "bg",
        },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
}
