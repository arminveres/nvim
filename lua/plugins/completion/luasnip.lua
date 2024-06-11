return {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    keys = {
        {
            "<C-k>",
            function()
                if require("luasnip").expand_or_jumpable() then
                    require("luasnip").expand_or_jump()
                end
            end,
            mode = { "i", "s" },
        },
        {
            "<C-j>",
            function()
                if require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                end
            end,
            mode = { "i", "s" },
        },
        {
            "<C-l>",
            function()
                if require("luasnip").choice_active() then
                    require("luasnip").change_choice(1)
                end
            end,
            mode = "i",
        },
        {
            "<C-u>",
            function()
                require("luasnip.extras.select_choice")
            end,
            mode = "i",
        },
    },
    config = function()
        local types = require("luasnip.util.types")
        local ls = require("luasnip")
        ls.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { " <- Current Choice", "NonTest" } },
                    },
                },
            },
        })

        require("luasnip/loaders/from_vscode").lazy_load()

        if vim.fn.has("win32") == 1 then -- Windows specific options
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { "~/AppData/Local/nvim/lua/user/snippets/vsc/" },
            })
        else
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { "~/.config/nvim/lua/user/snippets/vsc/" },
            })
        end

        require("snippets")
    end,
}
