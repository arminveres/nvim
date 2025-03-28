local file_finder_opts = {
    hidden = true,
    layout_config = {
        preview_width = 0.75,
    },
}

local telescope_mappings = {
    {
        "<bslash>e",
        function()
            require("telescope.builtin").find_files()
        end,
        desc = "Telescope Find Files",
    },
    {
        "<bslash>g",
        function()
            require("telescope.builtin").git_files()
        end,
        desc = "Telescope Find Git Files",
    },
    {
        "<leader>lb",
        function()
            require("telescope.builtin").buffers()
        end,
        desc = "Telescope Find Open Buffers",
    },
    {
        "<leader>sb",
        function()
            require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Telescope fuzzy search current buffer",
    },
    {
        "<leader>sh",
        function()
            require("telescope.builtin").help_tags()
        end,
        desc = "Telescope search help tags",
    },
    -- allow to grep for string under cursor
    {
        "<leader>sd",
        function()
            require("telescope.builtin").grep_string()
        end,
        desc = "Telescope search for string under cursor",
    },
    {
        "<leader>sp",
        function()
            require("telescope.builtin").live_grep()
        end,
        desc = "Telescope search for string",
    },
    {
        "<leader>gfb",
        "<cmd>Telescope git_branches<CR>",
        desc = "Telescope [f]ind [g]it [b]ranches",
    },
    {
        "<leader>k?",
        "<cmd>Telescope keymaps<CR>",
        desc = "Telescope List Keymaps",
    },
    {
        "<leader>r",
        "<cmd>Telescope resume<CR>",
        desc = "Telescope Resume Last Operation",
    },
    {
        "<leader>sg",
        "<cmd>Telescope grep_string search=<cr>",
        desc = "Telescope Search Globally",
    },
    {
        "<leader>fo",
        function()
            require("telescope.builtin").oldfiles()
        end,
        desc = "List oldfiles",
    },
}

local function telescope_setup()
    local t = require("telescope")
    local actions = require("telescope.actions")
    t.setup({
        defaults = {
            file_ignore_patterns = {
                ".git/",
                "node_modules/",
                ".cache/",
                "*.pdf",
                "*.png",
                "*.jpg",
            },
            prompt_prefix = "➜ ",
            selection_caret = "> ",
            path_display = { "smart" },
            mappings = {
                i = {
                    ["<C-k>"] = actions.cycle_history_next,
                    ["<C-j>"] = actions.cycle_history_prev,
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-c>"] = actions.close,
                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["<CR>"] = actions.select_default,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-l>"] = actions.complete_tag,
                    ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                },
                n = {
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["j"] = actions.move_selection_next,
                    ["k"] = actions.move_selection_previous,
                    ["H"] = actions.move_to_top,
                    ["M"] = actions.move_to_middle,
                    ["L"] = actions.move_to_bottom,
                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,
                    ["?"] = actions.which_key,
                },
            },
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
                height = 0.8,
                prompt_position = "top",
            },
        },
        pickers = {
            find_files = file_finder_opts,
            -- git_files = file_finder_opts,
            git_files = { recurse_submodules = false },
        },
        extensions = {},
    })
end

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = telescope_mappings,
    config = telescope_setup,
    cmd = "Telescope",
}
