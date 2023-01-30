return {
  "kyazdani42/nvim-tree.lua", -- Replacement for Netrw
  config = function()
    local tcfg = require("nvim-tree.config")
    local tree_callback = tcfg.nvim_tree_callback
    require("nvim-tree").setup({
      view = {
        number = true, -- default: false
        relativenumber = true, -- default: false
        signcolumn = "yes",
        mappings = {
          custom_only = false,
          list = {
            -- user mappings go here
            { key = { "l", "<CR>", "o" }, cb = tree_callback("edit") },
            { key = "h", cb = tree_callback("close_node") },
            { key = "v", cb = tree_callback("vsplit") },
          },
        },
      },
      renderer = {
        indent_markers = {
          enable = true,
          inline_arrows = true,
        },
        icons = {
          webdev_colors = true,
          glyphs = {
            git = {
              unstaged = "",
              staged = "S",
              unmerged = "",
              renamed = "➜",
              deleted = "-",
              untracked = "U",
              ignored = "◌",
            },
          },
        },
        group_empty = true,
      },
      update_focused_file = {
        -- adjusted for project.nvim
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      diagnostics = {
        enable = true, -- default: false
        show_on_dirs = true, -- default: false
      },
    })
  end,
}
