return {
  {
    "akinsho/bufferline.nvim", -- tabline replacement
    version = "v3.*",
    opts = {
      options = {
        mode = "tabs",
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        indicator = {
          style = "▎",
        },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        offsets = { { filetype = "NvimTree", text = "File Explorer", padding = 1 } },
        separator_style = "thick",
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },
}
