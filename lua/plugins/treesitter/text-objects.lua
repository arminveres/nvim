-- After a treesitter goto_*_start lands on a def node (function/class/...),
-- snap the cursor onto that node's name (the identifier itself) instead of
-- leaving it on the keyword/return-type/decorator start.

-- C-like grammars (C/C++/Go/Rust ptr types, etc.) nest the name behind a
-- chain of "declarator" fields (pointer_declarator -> function_declarator
-- -> identifier), separate from the "type" field (return type). Follow it.
-- qualified_identifier (Foo::bar) exposes the tail via "name", which can
-- itself be a nested qualified_identifier (Foo::Bar::baz) - keep descending
-- until we hit the innermost name.
local function resolve_qualified(node)
    while node and node:type() == "qualified_identifier" do
        node = node:field("name")[1] or node
    end
    return node
end

local function follow_declarator(node)
    while node do
        local t = node:type()
        if t:match("identifier$") then
            return resolve_qualified(node)
        end
        node = node:field("declarator")[1]
    end
end

-- Skip descending into these: parameters, generics, bodies - the name never
-- lives inside them, and descending would pick up unrelated identifiers.
local SKIP = {
    parameter_list = true, formal_parameters = true, parameters = true,
    type_parameters = true, type_arguments = true, template_parameter_list = true,
    template_argument_list = true,
    argument_list = true, arguments = true,
    block = true, statement_block = true, body = true, compound_statement = true,
}

local function last_identifier(node)
    local found
    for child, field in node:iter_children() do
        if child:named() and not SKIP[child:type()] and field ~= "body" then
            local t = child:type()
            if t:match("identifier$") then
                found = child
            else
                found = last_identifier(child) or found
            end
        end
    end
    return found
end

local function goto_name()
    local node = vim.treesitter.get_node()
    if not node then return end

    -- goto_next_start/goto_previous_start place the cursor at the exact
    -- start of the captured node (e.g. function_definition). get_node()
    -- gives the smallest node there, which can be a nested child (e.g. the
    -- return type's inner identifier) sharing the same start position.
    -- Climb to the outermost node still starting exactly here, that's the
    -- one the query actually captured.
    while true do
        local parent = node:parent()
        if not parent then break end
        local prow, pcol = parent:start()
        local nrow, ncol = node:start()
        if prow == nrow and pcol == ncol then
            node = parent
        else
            break
        end
    end

    local name = resolve_qualified(node:field("name")[1])
        or follow_declarator(node:field("declarator")[1])
        or last_identifier(node)
    if name then
        local row, col = name:start()
        vim.api.nvim_win_set_cursor(0, { row + 1, col })
    end
end

-- Move to the next/previous @function.outer, then snap onto its name.
-- Wrapped with make_repeatable_move (same as the plugin's own move.lua)
-- so ; and , repeat the move+snap combo, not just the bare move.
--
-- ; and , must keep repeating in the *original* ]m/[m direction (","
-- reverses just that one step, same as vim's f/t + ; /,). last_direction
-- holds that original direction and is only ever updated by the top-level
-- ]m/[m keymap (goto_function below), never by a repeat call. If we instead
-- re-registered last_move.opts using the per-call (possibly flipped) opts,
-- each ',' would flip relative to the previous flip and just toggle between
-- two functions instead of continuing to step backward.
local last_direction = true

local function goto_function_raw(opts)
    local move = require("nvim-treesitter-textobjects.move")
    if opts.forward then
        move.goto_next_start("@function.outer", "textobjects")
    else
        -- goto_name snaps the cursor onto the def's name, which sits to the
        -- right of the node's real start column. goto_previous_start only
        -- checks "is there a match before my cursor col", so leaving the
        -- cursor past col 0 makes the *current* function look like a valid
        -- previous match forever. Reset to col 0 first so it actually steps back.
        vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), 0 })
        move.goto_previous_start("@function.outer", "textobjects")
    end
    goto_name()

    -- move.goto_next_start/goto_previous_start are themselves wrapped with
    -- make_repeatable_move, so they clobber repeatable_move.last_move with
    -- the bare move (no name-snap) as their *last* act above. Re-register
    -- ourselves here, after that clobber, so ; and , repeat move+snap -
    -- always against the stable last_direction, not this call's opts.
    require("nvim-treesitter-textobjects.repeatable_move").last_move =
        { func = goto_function_raw, opts = { forward = last_direction }, additional_args = {} }
end

local goto_function = require("nvim-treesitter-textobjects.repeatable_move").make_repeatable_move(
    function(opts)
        last_direction = opts.forward
        goto_function_raw(opts)
    end
)

return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    -- dependencies = { "nvim-treesitter/nvim-treesitter", branch = "main" },
    opts = {
        select = {
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            -- You can choose the select mode (default is charwise 'v')

            selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V",  -- linewise
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
            -- "l=", this is annoying in visual mode, becase l, i.e., the right movement will wait
            -- for an operator.
            "=l",
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
        -- Jumps to @function.outer, then snaps onto the def's "name" field
        -- (works generically across languages, no per-language query needed).
        --
        -- goto_next_start/goto_previous_start are themselves wrapped as "the
        -- repeatable move" for ; and , (see repeatable_move.lua), but that
        -- wrapping only remembers the bare move, not our extra name-snap step.
        -- Whichever move runs last wins that slot, so after calling it we
        -- overwrite it with our own combo (move + snap) so ; and , repeat both.
        {
            mode = { "n", "x", "o" },
            "]m",
            function() goto_function({ forward = true }) end,
            { desc = "Next Function" },
        },
        {
            mode = { "n", "x", "o" },
            "[m",
            function() goto_function({ forward = false }) end,
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
