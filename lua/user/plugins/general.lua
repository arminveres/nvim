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
        "zbirenbaum/neodim", -- dim unused variables
        config = true,
        lazy = true,
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
        "ThePrimeagen/harpoon",
    },
    {
        "uga-rosa/ccc.nvim",
        keys = {
            {
                "<leader>bc",
                ":CccHighlighterToggle<CR>",
                mode = { "n" },
                desc = "Toggles Color Highlighting",
            },
            {
                "<leader>cp",
                ":CccPick<CR>",
                mode = { "n" },
                desc = "Toggles Color Picker",
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
    -- TODO: (aver) setup function: https://github.com/tzachar/local-highlight.nvim
    -- {
    --   "tzachar/local-highlight.nvim",
    --   config = function()
    --     require("local-highlight").setup()
    --   end,
    -- },
}
