local kopts = { noremap = true, silent = true }
return {
    {
        "kevinhwang91/nvim-hlslens", -- nicer search results
        opts = {},
        keys = {
            {
                "n",
                [[<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>]],
                kopts,
            },
            {

                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts,
            },
            {
                "*",
                [[*<Cmd>lua require('hlslens').start()<CR>]],
                kopts,
            },
            {
                "#",
                [[#<Cmd>lua require('hlslens').start()<CR>]],
                kopts,
            },
            {
                "g*",
                [[g*<Cmd>lua require('hlslens').start()<CR>]],
                kopts,
            },
            {
                "g#",
                [[g#<Cmd>lua require('hlslens').start()<CR>]],
                kopts,
            },
        },
    },
}
