-- Leader --
--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    ui = { border = "rounded" },
    defaults = { lazy = false },
    install = { missing = true, colorscheme = { "gruvbox" } },
    rocks = { enabled = false },
    spec = {
        { import = "plugins" },
        { import = "plugins.treesitter" },
        { import = "plugins.completion" },
        { import = "plugins.lsp" },
        { import = "plugins.ui" },
        { import = "plugins.debug" },
        { import = "plugins.snacks" },
        { import = "plugins.ai" },
    },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "zipPlugin",
                "tohtml",
                "tutor",
                "netrwPlugin",
                -- Needed for highlighting parenthesis, but replaceable by blink.pairs
                "matchit",
                "matchparen",
            },
        },
    },
})

-- move here, for some reason "SIXEL IMAGE 1x1" gets logged if called too early...
vim.cmd.colorscheme("gruvbox")
