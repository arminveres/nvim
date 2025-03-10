return {
    "arminveres/project.nvim", -- vim-rooter like replacement in neovim with many features
    -- event = "VeryLazy",
    keys = {
        {
            "<C-p>",
            function()
                require("telescope").extensions.projects.projects()
            end,
            { noremap = true },
        },
    },
    main = "project_nvim",
    opts = {
        detection_methods = { "pattern", "lsp" },
        manual_mode = false,
        show_hidden = true,
        silent_chdir = false,
        patterns = {
            ".git",
            "Cargo.toml",
            "Makefile",
            "package.json",
            "README.md",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            ".sln",
            ".slxn",
        },
    },
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
    },
}
