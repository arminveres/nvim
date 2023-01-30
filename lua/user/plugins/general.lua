-- NOTE: Use for plugins that don't require more than a simple setup
return {
  {
    "RaafatTurki/hex.nvim",
    config = true,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = true,
  },
  {
    "norcalli/nvim-colorizer.lua", -- colorizes color codes
    config = true,
  },
  {
    "ziontee113/color-picker.nvim", -- color picker
    config = function()
      require("color-picker").setup({
        ["icons"] = { "ﱢ", "" },
      })
    end,
  },
  {
    "zbirenbaum/neodim", -- dim unused variables
    config = true,
  },
  {
    "stevearc/dressing.nvim",
    config = true,
  },
  "ThePrimeagen/harpoon",
  { -- install without yarn or npm
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "junegunn/fzf",
    -- build = './install --bin',
  },
}
