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
    opts = { toc = false },
}
