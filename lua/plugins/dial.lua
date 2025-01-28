return {
    "monaqa/dial.nvim",
    keys = {
        { mode = { "n", "v" }, "<C-a>" },
        {
            mode = { "n", "v" },
            "<C-x>",
        },
        { mode = "v", "g<C-a>" },
        { mode = "v", "g<C-x>" },
    },
    config = function()
        local augend = require("dial.augend")

        local cap_boolean = augend.constant.new({
            elements = { "True", "False" },
            word = true,
            cyclic = true,
        })

        require("dial.config").augends:register_group({
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.binary,
                augend.integer.alias.hex,
                augend.constant.alias.bool,
                augend.date.alias["%Y/%m/%d"],
                cap_boolean,
            },
        })
        vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
        vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
        vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
        vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
        vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
        vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
    end,
}
