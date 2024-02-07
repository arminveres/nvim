return {
    "ahmedkhalf/project.nvim", -- vim-rooter like replacement in neovim with many features
    dependencies = "nvim-telescope/telescope.nvim",
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
        show_hidden = true,
        silent_chdir = false,
        patterns = {
            ".git",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "Makefile",
            "package.json",
            "README.md",
            "Cargo.toml",
        },
    },
}
