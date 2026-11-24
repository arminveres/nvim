-- plugins done by me
return {
    {
        -- dir = "~/Projects/md-pdf.nvim",
        "arminveres/md-pdf.nvim",
        enabled = true,
        keys = {
            {
                "<leader>,",
                function() require("md-pdf").convert_md_to_pdf() end,
                desc = "Markdown preview",
            },
        },
        ---@type md-pdf.config
        opts = {
            preview_cmd = "wsl-open",
            toc = false,
            ignore_viewer_state = true,
            output_path = "out",
        },
    },
    {
        -- only enable this for WSL/work
        enabled = os.getenv("WORK") ~= nil,
        dir = "~/Projects/raquezts.nvim/",
        dependencies = { "kiyoon/repeatable-move.nvim" },
        -- keys = { { "]r", desc = "Next PR [r]eview thread" }, { "[r", desc = "Previous PR [r]eview thread" } },
        config = function(_, opts)
            require("raquezts").setup(opts)
            local next_review, prev_review = require("repeatable_move").make_repeatable_move_pair(
                function() require("raquezts").next() end,
                function() require("raquezts").prev() end
            )
            vim.keymap.set("n", "]r", next_review, { desc = "Next PR [r]eview thread" })
            vim.keymap.set("n", "[r", prev_review, { desc = "Previous PR [r]eview thread" })
        end,
        opts = { token_file = "~/Projects/raquezts.nvim/token.json" },
    },
}
