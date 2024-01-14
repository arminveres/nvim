vim.g.skip_ts_context_commentstring_module = true

return {
    "JoosepAlviste/nvim-ts-context-commentstring", -- better context aware commenting
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "numToStr/Comment.nvim",
    },
    opts = {},
}
