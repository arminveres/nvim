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

            diagnostics.cppcheck.with({ extra_args = { "--disable=unusedStructMember" } }),
            diagnostics.zsh,
            diagnostics.gitlint,
            diagnostics.stylelint,

            formatting.stylua,
            formatting.prettier,
            formatting.shfmt,
            formatting.black, --.with({ extra_args = { "--fast" } }),
            formatting.stylelint,
            formatting.nixfmt.with({ extra_args = { "--width=100" } }),
            formatting.swift_format,
            require("none-ls.formatting.latexindent"),

            hover.dictionary,

            require("none-ls-shellcheck.diagnostics"),
            require("none-ls-shellcheck.code_actions"),
        },
    })
end

return {
    "nvimtools/none-ls.nvim", -- Null LS replacement
    event = "VeryLazy",
    config = setup,
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "nvim-lua/plenary.nvim",
        "gbprod/none-ls-shellcheck.nvim",
    },
}
