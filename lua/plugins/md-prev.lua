return {
    "iamcco/markdown-preview.nvim",
    keys = {
        {
            "<leader>mp",
            vim.cmd.MarkdownPreview,
            desc = "Preview markdown file in browser",
        }, -- open markdown preview
    },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
}
