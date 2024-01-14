return {
    -- TODO: (aver) add mappings to use this
    -- FIXME: (aver) or alternatively fix code-action insertion
    "ThePrimeagen/refactoring.nvim",
    event = "LspAttach",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
}
