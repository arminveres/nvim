vim.keymap.set("n", "<leader>m", ":MarkdownPreview<CR>", {
    desc = "Preview markdown file in browser"
}) -- open markdown preview

vim.opt_local.spell = true
vim.opt_local.conceallevel = 2 -- hide spaces too

vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
