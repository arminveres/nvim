return {
    "folke/snacks.nvim",
    keys = {
        {
            ",bdc",
            function()
                Snacks.bufdelete()
            end,
            desc = "[b]uffer [d]elete [c]urrent",
        },
        {
            ",bdo",
            function()
                Snacks.bufdelete.other()
            end,
            desc = "[b]uffer [d]elete [o]ther",
        },
    },
}
