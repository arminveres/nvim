return {
    "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
    main = "ibl",
    event = "BufEnter",
    opts = {
        -- char = "┊",
        -- show_trailing_blankline_indent = false,
        show_current_context_start = true,
        show_current_context = true,
        scope = {
            -- add further node types for scope highlighting, especially in lua with tables
            include = {
                node_type = {
                    lua = { "return_statement", "table_constructor" },
                    python = { "try_statement" },
                },
            },
        },
    },
}
