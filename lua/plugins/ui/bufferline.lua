return {
    "akinsho/bufferline.nvim", -- tabline replacement
    event = "TabEnter",
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            offsets = { { filetype = "netrw", text = "File Explorer", padding = 1 } },
            indicator = { style = "▎" },
        },
    },
}
