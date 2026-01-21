return {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>na",
            function() require("noice").cmd("all") end,
            desc = "Open [n]oice message [a]ll",
        },
        {
            "<leader>nh",
            function() require("noice").cmd("history") end,
            desc = "Open [n]oice message [h]istory",
        },
        {
            "<leader>nl",
            function() require("noice").cmd("last") end,
            desc = "Open [n]oice [l]ast message",
        },
    },
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
            signature = { auto_open = false },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            -- inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        messages = { view_search = "virtualtext" },
    },
    dependencies = "MunifTanjim/nui.nvim",
}
