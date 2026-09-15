return {
    "Wansmer/treesj",
    keys = {
        { "<space>m", function() require("treesj").toggle() end, desc = "Split join toggle" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    opts = { use_default_keymaps = false },
}
