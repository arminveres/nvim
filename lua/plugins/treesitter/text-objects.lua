return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter", branch = "main" },
    opts = {
        select = {
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            -- You can choose the select mode (default is charwise 'v')

            selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V", -- linewise
            },
            include_surrounding_whitespace = false,
        },
        move = {
            -- whether to set jumps in the jumplist
            set_jumps = true,
        },
    },
    keys = {
        -- Selects
        -- local select = require("nvim-treesitter-textobjects.select")
        {
            mode = { "x", "o" },
            "as",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@local.scope",
                    "locals"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "ac",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@class.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "ic",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@class.inner",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "il",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@loop.inner",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "al",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@loop.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "a=",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@assignment.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "i=",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@assignment.inner",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "l=",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@assignment.lhs",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "=r",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@assignment.rhs",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "aa",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@parameter.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "ia",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@parameter.inner",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "ai",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@conditional.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "ii",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@conditional.inner",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "af",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@call.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "if",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@call.inner",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "am",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@function.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "x", "o" },
            "im",
            function()
                require("nvim-treesitter-textobjects.select").select_textobject(
                    "@function.inner",
                    "textobjects"
                )
            end,
        },

        -- Swaps
        -- local swap = require("nvim-treesitter-textobjects.swap")
        {
            mode = "n",
            "<leader>ta",
            function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end,
            { desc = "Swap [t]reesitter parameter [a]vance (forward)" },
        },
        {
            mode = "n",
            "<leader>tA",
            function()
                require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
            end,
            { desc = "Swap [t]reesitter parameter [A]vance (previous)" },
        },

        -- Functions
        -- local move = require("nvim-treesitter-textobjects.move")
        {
            mode = { "n", "x", "o" },
            "]m",
            function()
                require("nvim-treesitter-textobjects.move").goto_next_start(
                    "@function.outer",
                    "textobjects"
                )
            end,
            { desc = "Next Function" },
        },
        {
            mode = { "n", "x", "o" },
            "[m",
            function()
                require("nvim-treesitter-textobjects.move").goto_previous_start(
                    "@function.outer",
                    "textobjects"
                )
            end,
            { desc = "Previous Function" },
        },

        -- calls
        {
            mode = { "n", "x", "o" },
            "]f",
            function()
                require("nvim-treesitter-textobjects.move").goto_next_start(
                    "@call.outer",
                    "textobjects"
                )
            end,
            { desc = "Next Function" },
        },
        {
            mode = { "n", "x", "o" },
            "[f",
            function()
                require("nvim-treesitter-textobjects.move").goto_previous_start(
                    "@call.outer",
                    "textobjects"
                )
            end,
            { desc = "Previous Function" },
        },

        -- Classes
        {
            mode = { "n", "x", "o" },
            -- "]c",
            "]]",
            function()
                require("nvim-treesitter-textobjects.move").goto_next_start(
                    "@class.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "n", "x", "o" },
            -- "[c",
            "[[",
            function()
                require("nvim-treesitter-textobjects.move").goto_previous_start(
                    "@class.outer",
                    "textobjects"
                )
            end,
        },

        -- Loops
        {
            mode = { "n", "x", "o" },
            "]l",
            function()
                require("nvim-treesitter-textobjects.move").goto_next_start(
                    { "@loop.inner", "@loop.outer" },
                    "textobjects"
                )
            end,
        },
        {
            mode = { "n", "x", "o" },
            "[l",
            function()
                require("nvim-treesitter-textobjects.move").goto_previous_start(
                    { "@loop.inner", "@loop.outer" },
                    "textobjects"
                )
            end,
        },

        -- Scope
        -- {
        --     { "n", "x", "o" },
        --     "]s",
        --     function() move.goto_next_start("@local.scope", "locals") end
        -- },
        -- {
        --     { "n", "x", "o" },
        --     "[s",
        --     function() move.goto_previous_start("@local.scope", "locals") end
        -- },

        -- Folds
        {
            mode = { "n", "x", "o" },
            "]z",
            function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
            end,
        },
        {
            mode = { "n", "x", "o" },
            "[z",
            function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
            end,
        },

        -- Go to either the start or the end, whichever is closer.
        -- Use if you want more granular movements
        {
            mode = { "n", "x", "o" },
            "]i",
            function()
                require("nvim-treesitter-textobjects.move").goto_next(
                    "@conditional.outer",
                    "textobjects"
                )
            end,
        },
        {
            mode = { "n", "x", "o" },
            "[i",
            function()
                require("nvim-treesitter-textobjects.move").goto_previous(
                    "@conditional.outer",
                    "textobjects"
                )
            end,
        },

        -- local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
        -- Repeat movement with ; and ,
        -- ensure ; goes forward and , goes backward regardless of the last direction
        -- {{ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next},
        -- {{ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous},

        -- vim way: ; goes to the direction you were moving.
        {
            mode = { "n", "x", "o" },
            ";",
            require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move,
        },
        {
            mode = { "n", "x", "o" },
            ",",
            require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_opposite,
        },

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        {
            mode = { "n", "x", "o" },
            "f",
            require("nvim-treesitter-textobjects.repeatable_move").builtin_f_expr,
            expr = true,
        },
        {
            mode = { "n", "x", "o" },
            "F",
            require("nvim-treesitter-textobjects.repeatable_move").builtin_F_expr,
            expr = true,
        },
        {
            mode = { "n", "x", "o" },
            "t",
            require("nvim-treesitter-textobjects.repeatable_move").builtin_t_expr,
            expr = true,
        },
        {
            mode = { "n", "x", "o" },
            "T",
            require("nvim-treesitter-textobjects.repeatable_move").builtin_T_expr,
            expr = true,
        },
    },
}
