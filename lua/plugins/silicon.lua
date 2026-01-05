return {
    "narutoxy/silicon.lua",
    opt = {},
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<Leader>cs",
            function() require("silicon").visualise_api({}) end,
            mode = { "v" },
        },
    },
}
