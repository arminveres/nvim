return {
    -- "glepnir/lspsaga.nvim",
    -- event = "LspAttach",
    -- opts = {
    --     ui = {
    --         title = true,
    --         border = "shadow",
    --         winblend = 15,
    --         code_action_icon = "💡", --
    --     },
    --     rename = {
    --         in_select = false, -- I don't see why we should be in select mode, caused me a lot of headaches
    --     },
    --     code_action = {
    --         extend_gitsigns = true, -- use gitsign either through lspsaga or null-ls
    --     },
    --     symbol_in_winbar = {
    --         enable = true,
    --     },
    -- },
    -- dependencies = {
    --     "nvim-tree/nvim-web-devicons",
    --     "nvim-treesitter/nvim-treesitter",
    --     "kevinhwang91/nvim-ufo",
    -- },
}

-- -- ================================================================================================
-- -- LSP Saga
-- -- ================================================================================================
-- -- Further remaps can be found under lspsaga/command.lua
-- vim.keymap.set("n", "[d", function()
--     -- vim.cmd("Lspsaga diagnostic_jump_prev")
--     require("lspsaga.diagnostic"):goto_prev()
-- end, opts)
-- vim.keymap.set("n", "]d", function()
--     -- vim.cmd("Lspsaga diagnostic_jump_next")
--     require("lspsaga.diagnostic"):goto_next()
-- end, opts)
-- vim.keymap.set("n", "K", function()
--     local winid = require("ufo").peekFoldedLinesUnderCursor()
--     if not winid then
--         -- vim.lsp.buf.hover()
--         vim.cmd([[Lspsaga hover_doc]])
--     end
-- end, opts)
-- vim.keymap.set({ "n", "v" }, "<leader>ca", function()
--     -- ":Lspsaga code_action<CR>"
--     require("lspsaga.codeaction"):code_action()
-- end, opts)
-- vim.keymap.set("n", "grn", function()
--     vim.cmd([[Lspsaga rename ++project]])
-- end, opts)
-- vim.keymap.set("n", "gh", function()
--     vim.cmd("Lspsaga finder")
-- end, opts)
-- vim.keymap.set("n", "<leader>at", function()
--     -- ":Lspsaga outline<CR>"
--     require("lspsaga.symbol"):outline()
-- end, opts)
-- vim.keymap.set("n", "gl", function()
--     vim.cmd([[Lspsaga show_line_diagnostics]])
-- end, opts)
-- vim.keymap.set("n", "<leader>gl", function()
--     vim.cmd([[Lspsaga show_cursor_diagnostics]])
-- end, opts)
-- vim.keymap.set("n", "<Leader>ci", function()
--     vim.cmd([[Lspsaga incoming_calls]])
-- end)
-- vim.keymap.set("n", "<Leader>co", function()
--     vim.cmd([[Lspsaga outgoing_calls]])
-- end)
-- keymap("n", "<leader>rn", ":Lspsaga rename ++project<CR>", opts)
-- keymap("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)
-- keymap("n", "<leader>gd", "<cmd>Lspsaga preview_definition<CR>", opts)
