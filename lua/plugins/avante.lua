return {
    enabled = true,
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        provider = "copilot",
        auto_suggestions_provider = "copilot",
        behaviour = { auto_approve_tool_permissions = false },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "folke/snacks.nvim",           -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        {
            "zbirenbaum/copilot.lua",  -- for providers='copilot'
            opts = {
                -- copilot_node_command = vim.fn.expand("$HOME")
                --     .. "/.config/nvm/versions/node/v24.8.0/bin/node", -- Node.js version must be > 22
                -- copilot_model = "claude-sonnet-4.5",
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = { file_types = { "markdown", "Avante" } },
            ft = { "markdown", "Avante" },
        },
    },
}
