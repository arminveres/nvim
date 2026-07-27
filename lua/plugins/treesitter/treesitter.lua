local parsers = {
    "bash",
    "bitbake",
    "c",
    "c_sharp",
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
    "jq",
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
    "regex",
    "rust",
    "toml",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zsh",
    "tmux",
}

vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.parsers").tmux = {
            install_info = {
                url = "https://github.com/Freed-Wu/tree-sitter-tmux",
                revision = "a03e0b76998d6a08ea33d14bc11409c8996f4ea7", -- commit hash for revision to check out; HEAD if missing
                -- optional entries:
                branch = "main", -- only needed if different from default branch
                -- location = "parser", -- only needed if the parser is in subdirectory of a "monorepo"
                -- generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
                -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
                queries = "queries", -- install highlights/folds/injections queries from this directory
            },
        }
    end,
})

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSInstall", "TSUninstall" },
    ft = require("utils").merge(parsers, { "cs" }),
    init = function()
        vim.g.no_plugin_maps = true
        vim.api.nvim_create_autocmd("FileType", {
            pattern = parsers,
            callback = function(ev) vim.treesitter.start(ev.buf) end,
        })
    end,
    config = function()
        require("nvim-treesitter").install(parsers)

        vim.treesitter.language.register("bash", "sh")
        vim.treesitter.language.register("xml", "xaml")
        vim.treesitter.language.register("c", "cl")
        vim.treesitter.language.register("cpp", "clpp")
        vim.treesitter.language.register("c_sharp", "cs")

        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
    end,
}
