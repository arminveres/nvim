return {
  "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
  "williamboman/mason.nvim", -- installer for lsps
  "williamboman/mason-lspconfig.nvim",
  "jose-elias-alvarez/null-ls.nvim", -- Null LS
  "jay-babu/mason-null-ls.nvim",
  "p00f/clangd_extensions.nvim", -- Clangd's off-spec features for neovim's LSP client
  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    branch = "main",
    opts = {
      ui = {
        title = true,
        border = "rounded",
        winblend = 15,
        code_action_icon = "💡", --
        colors = {
          normal_bg = "#000000",
        },
      },
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "j-hui/fidget.nvim", -- progress indicator for LSP
    opts = {
      text = {
        spinner = "dots", -- animation shown when tasks are ongoing
      },
    },
    config = function(_, opts)
      require("fidget").setup(opts)
    end,
  },
}
