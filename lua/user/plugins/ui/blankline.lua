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
  dependencies = {
    "ellisonleao/gruvbox.nvim",
    config = function()
      -- BUG: weird bug, where this is the only way, I can setup gruvbox, other colorschemes work without issues
      require("user.colorscheme")
    end,
  },
}
