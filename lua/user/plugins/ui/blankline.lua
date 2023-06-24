return {
  "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
  lazy = true,
  event = 'BufEnter',
  opts = {
    char = "┊",
    filetype_exclude = { "help", "packer" },
    buftype_exclude = { "terminal", "nofile" },
    char_highlight = "LineNr",
    show_trailing_blankline_indent = false,
    show_current_context_start = true,
    show_current_context = true,
  },
  config = function(_, opts)
    require("indent_blankline").setup(opts)
  end,
}
