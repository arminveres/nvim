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
    build = "cd app && npm install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
}
