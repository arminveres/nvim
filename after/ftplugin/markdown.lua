-- local opts = { silent = true, remap = false }
-- vim.keymap.set("n", "<leader>m", [[:MarkdownPreview<CR>]], opts) -- open markdown preview
vim.keymap.set("n", "<leader>m", ":MarkdownPreview<CR>", {
    desc = "Preview markdown file in browser"
}) -- open markdown preview
