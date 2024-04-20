local ts_langs = {
    "awk",
    "bash",
    "c",
    "cmake",
    "comment",
    "cpp",
    "cuda",
    "diff",
    "dockerfile",
    "doxygen",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "glsl",
    "go",
    "gomod",
    "gosum",
    "html",
    "htmldjango",
    "swift",
    "http",
    "hyprlang",
    "java",
    "javascript",
    "jq",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "latex",
    "llvm",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "meson",
    "ninja",
    "python",
    "query",
    "regex",
    "requirements",
    "ron",
    "rust",
    "scss",
    "sql",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zig",
}

local ts_opts = {
    ensure_installed = ts_langs,
    sync_install = true, -- ignore_install = { "" }, -- List of parsers to ignore installing
    indent = { enable = true },
    fold = { enable = false },
    autopairs = { enable = true },
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end

            -- we specifically disable highlighting, but as we need the parser for the folds, we
            -- need to leave the parser.
            if lang == "latex" then
                return true
            end
        end,
        additional_vim_regex_highlighting = {
            "dockerfile", -- nicer highlighting for some commands
            "markdown",
        },
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
        -- TODO: (aver) Add more textobject: https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/nvim-treesitter-text-objects.lua
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["a="] = {
                    query = "@assignment.outer",
                    desc = "Select outer part of an assignment",
                },
                ["i="] = {
                    query = "@assignment.inner",
                    desc = "Select inner part of an assignment",
                },
                ["=l"] = {
                    query = "@assignment.lhs",
                    desc = "Select left hand side of an assignment",
                },
                ["=r"] = {
                    query = "@assignment.rhs",
                    desc = "Select right hand side of an assignment",
                },

                -- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
                ["a:"] = {
                    query = "@property.outer",
                    desc = "Select outer part of an object property",
                },
                ["i:"] = {
                    query = "@property.inner",
                    desc = "Select inner part of an object property",
                },
                ["l:"] = {
                    query = "@property.lhs",
                    desc = "Select left part of an object property",
                },
                ["r:"] = {
                    query = "@property.rhs",
                    desc = "Select right part of an object property",
                },

                ["aa"] = {
                    query = "@parameter.outer",
                    desc = "Select outer part of a parameter/argument",
                },
                ["ia"] = {
                    query = "@parameter.inner",
                    desc = "Select inner part of a parameter/argument",
                },

                ["ai"] = {
                    query = "@conditional.outer",
                    desc = "Select outer part of a conditional",
                },
                ["ii"] = {
                    query = "@conditional.inner",
                    desc = "Select inner part of a conditional",
                },

                ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                ["am"] = {
                    query = "@function.outer",
                    desc = "Select outer part of a method/function definition",
                },
                ["im"] = {
                    query = "@function.inner",
                    desc = "Select inner part of a method/function definition",
                },

                ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
                ["<leader>n:"] = "@property.outer",  -- swap object property with next
                ["<leader>nm"] = "@function.outer",  -- swap function with next
            },
            swap_previous = {
                ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
                ["<leader>p:"] = "@property.outer",  -- swap object property with prev
                ["<leader>pm"] = "@function.outer",  -- swap function with previous
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = { query = "@call.outer", desc = "Next function call start" },
                ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
                ["]c"] = { query = "@class.outer", desc = "Next class start" },
                ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

                -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                -- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
                ["]F"] = { query = "@call.outer", desc = "Next function call end" },
                ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
                ["]C"] = { query = "@class.outer", desc = "Next class end" },
                ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
            },
            goto_previous_start = {
                ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
                ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
                ["[c"] = { query = "@class.outer", desc = "Prev class start" },
                ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
                ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
            },
            goto_previous_end = {
                ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
                ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
                ["[C"] = { query = "@class.outer", desc = "Prev class end" },
                ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
                ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
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
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-context",
        "HiPhish/nvim-ts-rainbow2", -- rainbow parenthesis
        "luckasRanarison/tree-sitter-hyprlang",
    },
    config = function()
        require("nvim-treesitter.configs").setup(ts_opts)

        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

        -- vim way: ; goes to the direction you were moving.
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

        vim.filetype.add({
            pattern = { [".*/hyprland%.conf"] = "hyprlang" },
        })
    end,
}
