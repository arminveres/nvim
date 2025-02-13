return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
        exclude = {
            buftypes = { "terminal" },
            filetypes = { "dashboard" },
        },
    },
}
