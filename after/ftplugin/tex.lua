vim.keymap.set("n", "<leader>vc", function()
    vim.cmd("VimtexCompile")
end, { desc = "[V]imTex [C]ompile and preview TeX file" })

vim.keymap.set("n", "<leader>vv", function()
    vim.cmd("VimtexView")
end, { desc = "[V]imTex Open pre[V]iew TeX file" })

vim.keymap.set("n", "<leader>vo", function()
    vim.cmd("VimtexTocToggle")
end, { desc = "[V]imTex: [O]pen Table of Contents for the TeX file" })

vim.keymap.set("n", "<leader>vcw", function()
    vim.cmd("VimtexCountWords")
end, { desc = "[V]imTex [C]ount [W]ords" })

vim.keymap.set("n", "<leader>vsl", function()
    vim.api.nvim_feedkeys("120|gEa\n", "n", true)
    -- only way to stop insert ...
    vim.api.nvim_input("<ESC>")
end, { desc = "[V]imTex: [S]plit [l]ine that are too long" })

vim.opt_local.spell = true
vim.opt_local.conceallevel = 2 -- hide spaces too, add nice icons
vim.opt_local.textwidth = 120

vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
