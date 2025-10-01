return {
    "folke/snacks.nvim",
    keys = {
        {
            "<leader>bdc",
            function()
                Snacks.bufdelete()
            end,
            desc = "[b]uffer [d]elete [c]urrent",
        },
        {
            "<leader>bdo",
            function()
                Snacks.bufdelete.other()
            end,
            desc = "[b]uffer [d]elete [o]ther",
        },
    },
}
