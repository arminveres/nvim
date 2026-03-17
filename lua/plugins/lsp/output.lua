return {
    "mhanberg/output-panel.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
        max_buffer_size = 5000,     -- default
    },
    cmd = { "OutputPanel" },
    keys = {
        {
            "<leader>o",
            vim.cmd.OutputPanel,
            mode = "n",
            desc = "Toggle the output panel",
        },
    },
}
