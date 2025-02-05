return {
    dir = "~/Projects/md-pdf.nvim",
    keys = {
        {
            "<leader>,",
            function()
                require("md-pdf").convert_md_to_pdf()
            end,
            desc = "Markdown preview",
        },
    },
    ---@type md-pdf.config
    opts = { toc = false, ignore_viewer_state = true },
}
