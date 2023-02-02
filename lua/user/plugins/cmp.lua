return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring", -- better context aware commenting
    },
    opts = function()
      local types = require("luasnip.util.types")
      return {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { " <- Current Choice", "NonTest" } },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local ls = require("luasnip")
      ls.config.set_config(opts)

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

      for _, lang in pairs({ "all", "sh", "c" }) do
        ls.add_snippets(lang, require("user.snippets." .. lang), { key = lang })
      end

      ls.filetype_extend("cpp", { "c" }) -- could use filetype_set, which blocks cpp snippets

    end,
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
  },
  { -- Autocompletion plugins
    "hrsh7th/nvim-cmp",
    -- event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "lukas-reineke/cmp-rg",
      {
        "petertriho/cmp-git",
        config = true,
      },
      "uga-rosa/cmp-dictionary", -- dictionary plugin
      "f3fora/cmp-spell", -- spelling plugin
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      {
        "windwp/nvim-autopairs", -- Autopairs {}, [], () etc
        config = true,
      },
      -- {'hrsh7th/cmp-vsnip'},
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local check_backspace = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
      end

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
      }
      -- find more here: https://www.nerdfonts.com/cheat-sheet

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item()
          --   elseif luasnip.expand_or_jumpable() then
          --     luasnip.expand_or_jump()
          --   elseif check_backspace() then
          --     fallback()
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              nvim_lua = "[NV_Lua]",
              path = "[Path]",
              buffer = "[Buffer]",
              dictionary = "[Dictionary]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
          { name = "path" },
          { name = "dictionary", keyword_length = 2 },
          --[[ { name = 'rg' }, ]]
          { name = "buffer" },
          { name = "spell" },
        }),
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          -- entries = 'native',
        },
        experimental = {
          ghost_text = true,
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Set configuration specifically for gitcommit
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = "buffer" },
        }),
      })

      -- dictionary setup
      require("cmp_dictionary").setup({
        dic = {
          ["markdown"] = { "~/.local/share/dict/eng.dict", "/usr/share/dict/linux.words" },
          -- ["*"] = { "/usr/share/dict/words" },
          -- ["lua"] = "path/to/lua.dic",
        },
        -- The following are default values, so you don't need to write them if you don't want to change them
        exact = 2,
        first_case_insensitive = false,
        async = true,
        capacity = 5,
        debug = false,
      })

      --[[
      -- more on: https://github.com/windwp/nvim-autopairs
      -- autopairs setup
      --]]
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
    end,
  },
}
