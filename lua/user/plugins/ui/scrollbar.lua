return {
    "petertriho/nvim-scrollbar", -- scrollbar
    event = "BufReadPre",
    opts = {
        handlers = {
            cursor = true,
            diagnostic = true,
            gitsigns = true, -- Requires gitsigns
            handle = true,
            search = true, -- Requires hlslens
        },
    },
    dependencies = {
        {
            "lewis6991/gitsigns.nvim",
            tag = "release",
            config = true,
        },
        "kevinhwang91/nvim-hlslens", -- nicer search results
    },
}
