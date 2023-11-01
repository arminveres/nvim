-- NOTE: Use for plugins that don't require more than a simple setup
return {
    {
        "RaafatTurki/hex.nvim",
        config = true,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = true,
    },
    {
        "stevearc/dressing.nvim",
        config = true,
    },
    {
        -- install without yarn or npm
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = "markdown",
        config = function()
            vim.g.mkdp_theme = "light"
        end,
    },
    {
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
    },
    {
        "chrishrb/gx.nvim",
        event = { "BufEnter" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true, -- default settings
    },
    {
        -- NOTE: See further config at lua/user/autocmds.lua
        "codethread/qmk.nvim",
        event = "BufEnter *arminveres/keymap.c",
    },
    {
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
    },
    {
        "numToStr/Comment.nvim", -- Comment out code easily
        opts = { ignore = "^$" },
        lazy = false,
    },
    {
        "RRethy/vim-illuminate", -- illuminate word under cursor lazy = true,
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 180,
            },
            alacritty = {
                enabled = true,
                font = "14", -- font size
            },
        },
    },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    -- TODO: (aver) setup function: https://github.com/tzachar/local-highlight.nvim
    -- {
    --   "tzachar/local-highlight.nvim",
    --   config = function()
    --     require("local-highlight").setup()
    --   end,
    -- },
}
