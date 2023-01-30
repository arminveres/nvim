local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "user.plugins" },
    { import = "user.plugins.ui" },
  },
  defaults = {
    performance = {
      rtp = {
        disabled_plugins = {
          "netrwPlugin",
        },
      },
    },
  },
  ui = {
    border = "rounded",
  },
})
