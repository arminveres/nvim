return {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = {
        "markdown",
        "neorg",
        "orgmode",
    },
    opts = {
        markdown = {
            headline_highlights = {
                "Headline1",
                "Headline2",
                "Headline3",
            },
        },
    },
}
