return {
    {
        dir = "~/gitfiles/md-pdf.nvim",
        lazy = true,
        config = function()
            vim.keymap.set("n", "<leader>,", require('md-pdf').convert_md_to_pdf, { desc = "Markdown preview" })
        end
    }
}
