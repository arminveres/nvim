return {
    "jay-babu/mason-null-ls.nvim",
    opts = {
        ensure_installed = {
            -- Opt to list sources here, when available in mason.
            "stylua",
            "jq",
            "shfmt",
            "gitlint",
            -- "latexindent",
        },
        automatic_installation = false,
        automatic_setup = true, -- Recommended, but optional
    },
}
