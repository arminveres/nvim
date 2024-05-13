return {
    "iamcco/markdown-preview.nvim",
    keys = {
        {
            "<leader>m",
            "<cmd>MarkdownPreview<CR>",
            desc = "Preview markdown file in browser",
        }, -- open markdown preview
    },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
}
