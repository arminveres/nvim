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
    defaults = {
        lazy = false,
    },
    install = {
        missing = true,
    },
    spec = {
        { import = "plugins" },
        { import = "plugins.completion" },
        { import = "plugins.lsp" },
        { import = "plugins.ui" },
        { import = "plugins.debug" },
    },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                -- "gzip",
                -- "tarPlugin",
                -- "tohtml",
                -- "tutor",
                -- "zipPlugin",
                -- "netrwPlugin",
                -- Needed for highlighting parenthesis
                -- "matchit",
                -- "matchparen",
            },
        },
    },
    ui = { border = "rounded" },
})
