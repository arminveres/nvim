-- BUG: does not run, causes segfault or other crash
return {
    "ThePrimeagen/refactoring.nvim",
    opts = {},
    keys = {
        {
            mode = { "n", "x" },
            "<leader>rr",
            function() require("refactoring").select_refactor() end,
            desc = "Refactor select",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}
