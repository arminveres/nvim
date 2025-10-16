return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        dim = {},
    },
    keys = {
        {
            "<leader>fd",
            function()
                if Snacks.dim.enabled then
                    Snacks.dim.disable()
                else
                    Snacks.dim.enable()
                end
            end,
            { desc = "Toggle [f]ocus [d]imming" },
        },
    },
}
