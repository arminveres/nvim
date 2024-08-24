return {
    {
        "MeanderingProgrammer/markdown.nvim",
        main = "render-markdown",
        ft = { "mardkown" },
        opts = {},
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    },
}
