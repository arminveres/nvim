local function setup()
    local null_ls = require("null-ls")

    -- code action sources
    local code_actions = null_ls.builtins.code_actions
    -- diagnostic sources
    local diagnostics = null_ls.builtins.diagnostics
    -- formatting sources
    local formatting = null_ls.builtins.formatting
    -- hover sources
    local hover = null_ls.builtins.hover
    -- completion sources
    local completion = null_ls.builtins.completion

    null_ls.setup({
        debug = false,
        sources = {
            -- code_actions.refactoring,
            require("none-ls-shellcheck.code_actions"),

            diagnostics.cppcheck.with({
                -- filetypes = { "c, cpp, cuda" },
                extra_args = { "--disable=unusedStructMember" },
            }),
            diagnostics.zsh,
            diagnostics.gitlint,
            diagnostics.stylelint,
            require("none-ls-shellcheck.diagnostics"),

            formatting.dockerfmt,
            formatting.stylua,
            -- exclude markdown so we can let other formatter do it (bullet point formatting)
            formatting.prettier.with({
                disabled_filetypes = { "markdown" },
            }),
            formatting.mdformat.with({
                extra_args = {
                    -- https://github.com/hukkin/mdformat
                    -- apply consecutive numbering
                    "--number",
                },
            }),
            formatting.shfmt,
            formatting.black, --.with({ extra_args = { "--fast" } }),
            formatting.stylelint,
            formatting.nixfmt.with({ extra_args = { "--width=100" } }),
            formatting.swift_format,
            require("none-ls.formatting.latexindent"),

            hover.dictionary,
            hover.printenv,
        },
    })
end

return {
    "nvimtools/none-ls.nvim", -- Null LS replacement
    -- event = "VeryLazy",
    config = setup,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvimtools/none-ls-extras.nvim",
        "gbprod/none-ls-shellcheck.nvim",
    },
}
