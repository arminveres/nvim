vim.keymap.set("n", "<leader>vc", ":VimtexCompile<CR>", { desc = "Compile and preview TeX file" })
vim.keymap.set("n", "<leader>vv", ":VimtexView<CR>", { desc = "Open preview TeX file" })
vim.keymap.set("n", "<leader>vo", ":VimtexTocToggle<CR>", { desc = "Open Table of Contents for the TeX file" })
vim.keymap.set("n", "<leader>vsl", "120|gEa<CR><ESC>", { desc = "split line that are too long" })

vim.opt_local.spell = true
vim.opt_local.conceallevel = 2 -- hide spaces too, add nice icons
vim.opt_local.textwidth = 120

vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
