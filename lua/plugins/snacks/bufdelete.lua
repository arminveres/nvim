return {
    "folke/snacks.nvim",
    keys = {
        {
            "<bslash>bdc",
            function()
                Snacks.bufdelete()
            end,
            desc = "[b]uffer [d]elete [c]urrent",
        },
        {
            "<bslash>bdo",
            function()
                Snacks.bufdelete.other()
            end,
            desc = "[b]uffer [d]elete [o]ther",
        },
    },
}
