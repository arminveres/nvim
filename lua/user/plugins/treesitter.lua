local ts_opts = {
    ensure_installed = "all",
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "latex", "bibtex" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = { "markdown" },
    },
    indent = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
    },
    fold = {
        enable = false,
    },
    rainbow = {
        enable = false,
        -- disable = { "jsx", "cpp" }, -- list of languages you want to disable the plugin for
        -- extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        query = {
            "rainbow-parens",
            html = "rainbow-tags",
            latex = "rainbow-blocks",
        }, -- Which query to use for finding delimiters
        -- strategy = require("ts-rainbow.strategy.global"), -- Highlight the entire buffer all at once
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
    textobjects = {
        --[[
    -- additional textobjects
        @attribute.inner
        @attribute.outer
        @block.inner
        @block.outer
        @call.inner
        @call.outer
        @class.inner
        @class.outer
        @comment.outer
        @conditional.inner
        @conditional.outer
        @frame.inner
        @frame.outer
        @function.inner
        @function.outer
        @loop.inner
        @loop.outer
        @parameter.inner
        @parameter.outer
        @scopename.inner
        @statement.outer
    --]]
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = {
                    query = "@function.outer",
                    desc = "Select outer part of function/method",
                },
                ["if"] = {
                    query = "@function.inner",
                    desc = "Select inner part of function/method",
                },
                ["ac"] = { query = "@class.outer", desc = "Select outer part of class" },
                ["ic"] = { query = "@class.inner", desc = "Select innter part of class" },
                ["ab"] = {
                    query = "@conditional.outer",
                    desc = "Select outer part of conditional",
                },
                ["ib"] = {
                    query = "@conditional.inner",
                    desc = "Select inner part of conditional",
                },
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>aa"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = true,
            border = "none",
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dF"] = "@class.outer",
            },
        },
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = false }, -- I use the indent plugin
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },
    },
}

return {
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-context",
        "HiPhish/nvim-ts-rainbow2", -- rainbow parenthesis
        "JoosepAlviste/nvim-ts-context-commentstring", -- better context aware commenting
        {
            "numToStr/Comment.nvim", -- Comment out code easily
            opts = { ignore = "^$" },
            config = true,
            lazy = true,
        },
    },
    config = function()
        require("nvim-treesitter.configs").setup(ts_opts)
    end,
    event = { "BufReadPre", "BufNewFile" },
}
