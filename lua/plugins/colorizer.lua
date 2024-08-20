return {
    "uga-rosa/ccc.nvim",
    enabled = false,
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
    -- TODO(aver): wait for newer version, where utf8 error does not interfere with nixd
    event = "VeryLazy",
}
