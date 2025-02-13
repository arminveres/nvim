return {
    "RaafatTurki/hex.nvim",
    keys = {
        {
            "<leader>ht",
            function()
                require("hex").toggle() -- switch back and forth
            end,
            desc = "[h]ex [t]oggle",
        },
    },
}
