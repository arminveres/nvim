return {
    "JoosepAlviste/nvim-ts-context-commentstring", -- better context aware commenting
    -- event = "VeryLazy",
    keys = { "gc" },
    opts = {},
    init = function() vim.g.skip_ts_context_commentstring_module = true end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "numToStr/Comment.nvim",
    },
}
