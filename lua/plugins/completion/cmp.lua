local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
} -- find more here: https://www.nerdfonts.com/cheat-sheet

local function cmp_config()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- local check_backspace = function()
    --   local col = vim.fn.col(".") - 1
    --   return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    -- end

    cmp.setup({
        -- preselect = 'None',
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = cmp.mapping.preset.insert({
            -- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }), -- 'forward'
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }), -- 'backward'
            -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- Accept currently selected item. If none selected, `select` first item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                -- Kind icons
                -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

                -- NOTE: This concatonates the icons with the name of the item kind
                vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)

                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snip]",
                    path = "[Path]",
                    buffer = "[Buf]",
                    dictionary = "[Dict]",
                })[entry.source.name]
                return vim_item
            end,
        },
        sources = cmp.config.sources({
            { name = "luasnip", priority = 1000 },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "dictionary", keyword_length = 2 },
            { name = "buffer" },
            {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            },
            -- { name = "spell" },
            -- { name = 'rg' },
        }),
        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        experimental = {
            ghost_text = true,
        },

        -- window = {
        --   completion = cmp.config.window.bordered(),
        --   documentation = cmp.config.window.bordered(),
        -- },
        -- WARN: Disable native completion, conflicting with preview
        -- view = { entries = "native" },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            -- { name = "path" },
            {
                name = "cmdline",
                option = {
                    ignore_cmds = { "Man", "!" },
                },
            },
        }),
        -- use only the text
        formatting = { fields = { "abbr" } },
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
            { name = "nvim_lsp_document_symbol" },
        },
        -- use only the text
        formatting = { fields = { "abbr" } },
    })

    -- more on: https://github.com/windwp/nvim-autopairs autopairs setup
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local handlers = require("nvim-autopairs.completion.handlers")
    cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done({
            filetypes = {
                -- "*" is a alias to all filetypes
                ["*"] = {
                    ["("] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method,
                        },
                        handler = handlers["*"],
                    },
                },
                -- Disable for tex
                tex = false,
            },
        })
    )
end

return {
    "hrsh7th/nvim-cmp",
    -- event = { "InsertEnter", "CmdlineEnter" },
    event = "VeryLazy",
    config = cmp_config,
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-cmdline",
        "lukas-reineke/cmp-rg",
        "f3fora/cmp-spell", -- spelling plugin
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
}
