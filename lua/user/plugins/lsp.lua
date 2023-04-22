return {
  "neovim/nvim-lspconfig",           -- Collection of configurations for built-in LSP client
  "williamboman/mason.nvim",         -- installer for lsps
  "williamboman/mason-lspconfig.nvim",
  "jose-elias-alvarez/null-ls.nvim", -- Null LS
  "jay-babu/mason-null-ls.nvim",
  "p00f/clangd_extensions.nvim",     -- Clangd's off-spec features for neovim's LSP client
  "simrat39/rust-tools.nvim",
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    branch = "main",
    opts = {
      ui = {
        title = true,
        border = "shadow",
        winblend = 15,
        code_action_icon = "💡", --
      },
      -- symbol_in_winbar = { enable = false }
      rename = {
        in_select = false -- I don't see why we should be in select mode, caused me a lot of headaches
      },
      code_action = {
        extend_gitsigns = true, -- use gitsign either through lspsaga or null-ls
      }
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  }
}
