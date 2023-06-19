return {
    {
        dir = "~/projects/md-pdf.nvim",
        lazy = true,
        keys = { { '<leader>,' } },
        config = function()
            vim.keymap.set("n", "<leader>,", require('md-pdf').convert_md_to_pdf, { desc = "Markdown preview" })
        end
    }
}
