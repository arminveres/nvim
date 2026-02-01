-- vim.api.nvim_create_autocmd("User", {
--     pattern = "BlinkCmpMenuOpen",
--     callback = function() vim.b.copilot_suggestion_hidden = true end,
-- })

-- vim.api.nvim_create_autocmd("User", {
--     pattern = "BlinkCmpMenuClose",
--     callback = function() vim.b.copilot_suggestion_hidden = false end,
-- })
return {
    enabled = false,
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
        copilot_node_command = vim.fn.expand("$HOME")
            .. "/.config/nvm/versions/node/v25.2.1/bin/node", -- Node.js version must be > 22
        -- panel = { enabled = false, },
        -- suggestion = { enabled = false },
        -- filetypes = {
        --     markdown = true,
        --     help = true,
        -- },
        nes = { enabled = true, keymap = { accept_and_goto = "<leader>p", accept = false, dismiss = "<Esc>", }, },
    },
    dependencies = { "copilotlsp-nvim/copilot-lsp", init = function() vim.g.copilot_nes_debounce = 500 end, },
}
