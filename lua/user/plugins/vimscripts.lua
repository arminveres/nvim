-- Vimtex options
vim.g.vimtex_compiler_latexmk = {
    options = {
        "--shell-escape",
        "--verbose",
        "--file-line-error",
        "--synctex=1",
        "--interaction=nonstopmode",
    },
}
vim.g.vimtex_view_automatic = 0
vim.g.vimtex_quickfix_open_on_warning = 0

return {
    { "lervag/vimtex", ft = "tex" },
    { "fladson/vim-kitty", ft = "kitty" },
    -- { "ron-rs/ron.vim", ft = "ron" },
    { "mboughaba/i3config.vim", ft = "i3config" },
    { "tridactyl/vim-tridactyl", ft = "tridactyl" },
    {
        "mbbill/undotree",
        lazy = true,
        cmd = "UndotreeToggle",
    },
    "tpope/vim-sleuth", -- automatically adjusts 'shiftwidth' and 'expandtab' based on the current file
    "moll/vim-bbye", -- allows you to do delete buffers (close files) without closing your windows

    -- { "zefei/vim-colortuner", cmd = "Colortuner", },
    -- "ludovicchabant/vim-gutentags", -- Automatic tags management
    -- 'tpope/vim-fugitive', -- Git commands in nvim
    -- 'tpope/vim-rhubarb', -- Fugitive-companion to interact with github
}
