return {
    "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
    main = "ibl",
    lazy = true,
    event = "BufEnter",
    opts = {
        -- char = "┊",
        -- show_trailing_blankline_indent = false,
        show_current_context_start = true,
        show_current_context = true,
    },
    config = true,
}
