-- Vimtex options
return {
    "lervag/vimtex",
    ft = "tex",
    init = function()
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
    end,
}
