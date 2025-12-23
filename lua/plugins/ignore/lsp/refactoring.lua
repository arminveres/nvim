return {
    -- BUG: does not run, causes segfault or other crash
    "ThePrimeagen/refactoring.nvim",
    event = "LspAttach",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    -- TODO: add mappings to use this
}
