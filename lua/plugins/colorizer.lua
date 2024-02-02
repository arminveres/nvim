return {
    "uga-rosa/ccc.nvim",
    keys = {
        {
            "<leader>bc",
            function()
                vim.cmd("CccHighlighterToggle")
            end,
            desc = "[B]uffer [c]olorize",
        },
        {
            "<leader>cp",
            function()
                vim.cmd("CccPick")
            end,
            desc = "Toggles [C]olor [P]icker",
        },
    },
    opts = {
        highlighter = {
            auto_enable = true,
        },
    },
    -- event = 'VeryLazy'
    lazy=false
}
