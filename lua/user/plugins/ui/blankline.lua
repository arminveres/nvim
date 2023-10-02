return {
    "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
    main = "ibl",
    event = "BufEnter",
    opts = {
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
