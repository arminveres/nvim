return {
    "NickvanDyke/opencode.nvim",
    keys = {
        {
            mode = { "n", "x" },
            "<leader>aa",
            function() require("opencode").ask("@this: ", { submit = true }) end,
            desc = "Ask opencode…",
        },
        {
            mode = { "n", "x" },
            "<leader>ax",
            function() require("opencode").select() end,
            { desc = "Execute opencode action…" },
        },
        {
            mode = {
                "n", --[[ "t" ]]
            },
            "<leader>at",
            function() require("opencode").toggle() end,
            desc = "Toggle opencode",
        },
        {
            mode = { "n", "x" },
            "go",
            function() return require("opencode").operator("@this ") end,
            desc = "Add range to opencode",
            expr = true,
        },
        {
            mode = "n",
            "goo",
            function() return require("opencode").operator("@this ") .. "_" end,
            desc = "Add line to opencode",
            expr = true,
        },
        {
            mode = "n",
            "<S-C-u>",
            function() require("opencode").command("session.half.page.up") end,
            desc = "Scroll opencode up",
        },
        {
            mode = "n",
            "<S-C-d>",
            function() require("opencode").command("session.half.page.down") end,
            desc = "Scroll opencode down",
        },
    },
    config = function()
        local opencode_cmd = "opencode --port"
        ---@type snacks.terminal.Opts
        local snacks_terminal_opts = {
            win = {
                position = "right",
                enter = false,
                on_win = function(win)
                    -- Set up keymaps and cleanup for an arbitrary terminal
                    require("opencode.terminal").setup(win.win)
                end,
            },
        }
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            server = {
                start = function()
                    require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
                end,
                stop = function()
                    require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
                end,
                toggle = function()
                    require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
                end,
            },
        }
        -- Required for `opts.events.reload`.
        vim.o.autoread = true
    end,
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        {
            "folke/snacks.nvim",
            opts = {
                input = {},
                picker = {

                    actions = {
                        opencode_send = function(...)
                            return require("opencode").snacks_picker_send(...)
                        end,
                    },
                    win = {
                        input = {
                            keys = {
                                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                            },
                        },
                    },
                },
                terminal = {},
            },
        },
    },
}
