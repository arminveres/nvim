return {
    "akinsho/bufferline.nvim", -- tabline replacement
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            offsets = { { filetype = "netrw", text = "File Explorer", padding = 1 } },
            indicator = { style = "▎" },
        },
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
        vim.opt.showtabline = 1
    end,
}
