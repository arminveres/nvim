return {
    "https://git.sr.ht/~p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    keys = {
        { "<leader>gs", "<cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch to source or header" },
    },
}
