return {
  {
    "echasnovski/mini.bracketed",
    version = false,
    config = function()
      require("mini.bracketed").setup({
        comment = { suffix = "c", options = {} },
        conflict = { suffix = "x", options = {} },
        file = { suffix = "f", options = {} },
        indent = { suffix = "i", options = {} },
        jump = { suffix = "j", options = {} },
        location = { suffix = "l", options = {} },
        oldfile = { suffix = "o", options = {} },
        quickfix = { suffix = "q", options = {} },
        treesitter = { suffix = "t", options = {} },
        undo = { suffix = "u", options = {} },
        window = { suffix = "w", options = {} },
        yank = { suffix = "y", options = {} },
        -- disable the following:
        buffer = { suffix = "", options = {} },
        diagnostic = { suffix = "", options = {} },
      })
    end,
    dependencies = {
      { "echasnovski/mini.nvim", version = false, },
    },
  },
}
