vim.opt.textwidth = 120

vim.keymap.set("n", "<leader>vc", ":VimtexCompile<CR>", { desc = "Compile and preview TeX file" }) -- open markdown preview
vim.keymap.set("n", "<leader>vv", ":VimtexView<CR>", { desc = "Open preview TeX file" }) -- open markdown preview
