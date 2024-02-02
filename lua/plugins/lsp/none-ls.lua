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

            -- diagnostics.cpplint,
            diagnostics.cppcheck,
            diagnostics.zsh,
            diagnostics.shellcheck,
            -- diagnostics.commitlint,
            diagnostics.gitlint,
            diagnostics.stylelint,

            formatting.stylua,
            formatting.prettier,
            formatting.shfmt,
            formatting.black, --.with({ extra_args = { "--fast" } }),
            formatting.beautysh,
            formatting.stylelint,

            hover.dictionary,
        },
    })
end

return {
    "nvimtools/none-ls.nvim", -- Null LS replacement
    config = setup,
    dependencies = "nvim-lua/plenary.nvim",
}
