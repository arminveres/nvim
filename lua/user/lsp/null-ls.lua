local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    vim.notify("null_ls not ok")
    return
end

local status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not status_ok then
    vim.notify("mason_null_ls not ok")
    return
end

mason_null_ls.setup({
    ensure_installed = {
        -- Opt to list sources here, when available in mason.
        "stylua",
        "jq",
        "shfmt",
        "gitlint",
        "latexindent",
        "shellcheck",
    },
    automatic_installation = false,
    automatic_setup = true, -- Recommended, but optional
})

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
        -- code_actions.gitsigns,

        -- diagnostics.cpplint,
        diagnostics.cppcheck,
        diagnostics.zsh,
        diagnostics.shellcheck,
        -- diagnostics.commitlint,
        diagnostics.gitlint,
        -- diagnostics.ruff,
        diagnostics.stylelint,

        -- formatting.stylua,
        formatting.prettier.with({ extra_args = { "--single-quote", "--jsx-single-quote" } }),
        formatting.shfmt,
        formatting.latexindent,
        -- formatting.ruff,
        -- formatting.shfmt.with({ extra_args = { '--indent', '4' } }),
        formatting.black, --.with({ extra_args = { "--fast" } }),
        formatting.beautysh,
        formatting.stylelint,

        hover.dictionary,
    },
})
