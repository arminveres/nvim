local rt = require("rust-tools")
rt.setup({
    tools = {
        autosethints = true,
        inlay_hints = {
            show_parameter_hints = true,
            -- parameter_hints_prefix = " ",
            -- other_hints_prefix = " ",
            auto = false,
        },
        -- hover_actions = { auto_focus = true }
    },
    server = {
        on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
        settings = {
            diagnostics = {
                experimental = {
                    enable = true
                },
            },
            lens = {
                enable = true,
            },
            checkonsave = {
                command = "clippy",
            },
        }
    },
})
