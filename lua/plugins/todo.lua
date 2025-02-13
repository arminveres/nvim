return {
    "folke/todo-comments.nvim",
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
        {
            "[t",
            function() require("todo-comments").jump_prev() end,
            desc = "Previous TODO comment",
        },
    },
    opts = {
        search = { pattern = "[[\b(KEYWORDS).*:?]]" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
}
