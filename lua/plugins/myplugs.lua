-- plugins done by me
return {
    {
        -- dir = "~/Projects/md-pdf.nvim",
        "arminveres/md-pdf.nvim",
        enabled = true,
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
    },
}
