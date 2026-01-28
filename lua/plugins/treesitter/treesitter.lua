local parsers = {
    "awk",
    "bash",
    "bitbake",
    "c",
    "cmake",
    "comment", -- handy for todo items, hyprlinks
    "cpp",
    "cuda",
    "diff",
    "dockerfile",
    "doxygen",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "html",
    "htmldjango",
    "http",
    "hyprlang",
    "java",
    "javascript",
    "jq",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "meson",
    "ninja",
    "nix",
    "python",
    "query",
    "regex",
    "requirements",
    "rust",
    "scss",
    "sql",
    "tmux",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zsh",
}

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        for _, parser in ipairs(parsers) do
            ts.install(parser)
        end

        vim.treesitter.language.register("bash", "sh")
        vim.treesitter.language.register("xml", "xaml")
        vim.treesitter.language.register("c", "cl")
        vim.treesitter.language.register("cpp", "clpp")

        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"

        vim.api.nvim_create_autocmd("FileType", {
            pattern = parsers,
            callback = function() vim.treesitter.start() end,
        })
    end,
}
