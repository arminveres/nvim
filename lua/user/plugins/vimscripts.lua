vim.g.vimtex_compiler_latexmk = {
  options = {
    '--shell-escape',
    '--verbose',
    '--file-line-error',
    '--synctex=1',
    '--interaction=nonstopmode'
  }
}
return {
  { "lervag/vimtex", ft = "tex" },
  { "fladson/vim-kitty", ft = "kitty" },
  { "ron-rs/ron.vim", ft = "ron" },
  { "mboughaba/i3config.vim", ft = "i3config" },
  {
    "RRethy/vim-illuminate",
    lazy = true,
  }, -- illuminate word under cursor
  "tpope/vim-sleuth", -- automatically adjusts 'shiftwidth' and 'expandtab' based on the current file
  "ludovicchabant/vim-gutentags", -- Automatic tags management
  "moll/vim-bbye", -- allows you to do delete buffers (close files) without closing your windows
  "mbbill/undotree",
  -- 'tpope/vim-fugitive',                     -- Git commands in nvim
  -- 'tpope/vim-rhubarb',                      -- Fugitive-companion to interact with github
}
