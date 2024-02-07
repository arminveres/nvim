return {
    "stevearc/dressing.nvim",
    opts = {
        select = {
            -- Set to false to disable the vim.ui.select implementation
            enabled = true,
            -- Priority list of preferred vim.select implementations
            backend = { "builtin", "nui", "telescope", "fzf_lua", "fzf" },
        },
    },
}
