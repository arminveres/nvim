return {
  "petertriho/nvim-scrollbar", -- scrollbar
  config = function()
    require("scrollbar").setup({
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        handle = true,
        search = true, -- Requires hlslens
      },
    })
  end,
  dependencies = {
    {
      "lewis6991/gitsigns.nvim",
      tag = 'release',
      config = true,
    },
    "kevinhwang91/nvim-hlslens", -- nicer search results
  },
}
