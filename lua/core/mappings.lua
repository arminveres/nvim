local merge_desc = require("core.utils").merge_desc
local keymap = vim.keymap.set

-- Non recursive map map
---@type table
local opts = { noremap = true, silent = true }

-- Recurisve map
---@type table
local remopts = { noremap = false, silent = true }

-- Leader --
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ================================================================================================
-- NeoVIM CORE
-- ================================================================================================
-- Normal Mode --
keymap("n", "<ESC>", ":noh<CR>", remopts) -- recursively redefine escape; disable hlsearch until next search

--Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- No arrow keys. Force yourself to use the home row
keymap("n", "<Up>", "<Nop>", opts)
keymap("n", "<Down>", "<Nop>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Y yank until the end of line  (note: this is now a default on master)
keymap("n", "Y", "y$", { noremap = true })

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
-- keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
-- keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
-- Only move the text, don't go into insert more
keymap("n", "<A-j>", "<Esc>:m .+1<CR>", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>", opts)

-- Navigate tabs
keymap("n", "<C-t>", ":$tabnew<CR>", opts)
keymap("n", "<leader>tc", ":tabclose<CR>", opts)
keymap("n", "<leader>to", ":tabonly<CR>", opts)
keymap("n", "<leader>tn", ":tabn<CR>", opts)
keymap("n", "<leader>tp", ":tabp<CR>", opts)
-- move current tab to previous position
keymap("n", "<leader>tmp", ":-tabmove<CR>", opts)
-- move current tab to next position
keymap("n", "<leader>tmn", ":+tabmove<CR>", opts)

-- Insert Mode --
-- Map kj to the escape key
keymap("i", "kj", "<Esc>", opts)

-- Visual Mode --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts) -- when pasting in visual, don't copy deleted word to register

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Spell Checking --
keymap("n", "<F11>", ":set spell!<CR>", opts)
keymap("i", "<F11><C-O>", ":set spell!<CR>", opts)
-- replacing is done in insertmode <C-x>s

-- center up and down jumps
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)

-- CTRL-A Insert previously inserted text.
keymap("i", "<C-A>", "<ESC>A", opts)

-- keymap('n', '<leader>fe', ':Lex 30<cr>', opts) -- made obsolete by nvim-tree
-- ================================================================================================
-- CLIPBOARD
-- ================================================================================================
keymap("n", "<leader>bq", ":Bdelete<CR>", opts)
keymap("n", "\\q", ":q<CR>", opts)
keymap("n", "\\Q", "<Cmd>qall<CR>", opts) -- quickquit
keymap("n", "\\w", "<Cmd>w<CR>", opts) -- quick save
-- keymap("n", "<leader>.", ":so ~/.config/nvim/init.lua<CR>", opts)

-- Yank to clipboard
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+Y', remopts)
-- Paste from clipboad
keymap("n", "<leader>p", '"+p', opts)
keymap("n", "<leader>P", '"+P', opts)
--[[ keymap('v', '<leader>p', '"+p', opts) ]]
--[[ keymap('v', '<leader>P', '"+P', opts) ]]
-- delete into nirvana
keymap("n", "<leader>d", '"_d', opts)
keymap("v", "<leader>d", '"_d', opts)
-- According to thePrimeagen, the greatest map ever
keymap("x", "<leader>p", '"_dP', opts)

--Add leader shortcuts
----------------------------------------------------------------------------------------------------
-- Telescope
----------------------------------------------------------------------------------------------------
-- TODO: (aver) move into telescope plugin file

-- keymap('n', '<leader><space>', function()
--   require('telescope.builtin').buffers()
-- end, opts)
keymap("n", "\\e", function()
    require("telescope.builtin").find_files()
end, merge_desc(opts, "Telescope Find Files"))
keymap("n", "<leader>g", function()
    require("telescope.builtin").git_files()
end, merge_desc(opts, "Telescope Find Git Files"))
keymap("n", "\\b", function()
    require("telescope.builtin").buffers()
end, merge_desc(opts, "Telescope Find Open Buffers"))
keymap("n", "<leader>sb", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
end, merge_desc(opts, "Telescope fuzzy search current buffer"))
keymap("n", "<leader>sh", function()
    require("telescope.builtin").help_tags()
end, merge_desc(opts, "Telescope search help tags"))
-- allow to grep for string under cursor
keymap("n", "<leader>sd", function()
    require("telescope.builtin").grep_string()
end, merge_desc(opts, "Telescope search for string under cursor"))
keymap("n", "<leader>sp", function()
    require("telescope.builtin").live_grep()
end, merge_desc(opts, "Telescope search for string"))
keymap(
    "n",
    "<leader>gfb",
    ":Telescope git_branches<CR>",
    merge_desc(opts, "Telescope [f]ind [g]it [b]ranches")
)
keymap("n", "<leader>?", ":Telescope keymaps<CR>", merge_desc(opts, "Telescope List Keymaps"))
keymap(
    "n",
    "<leader>r",
    ":Telescope resume<CR>",
    merge_desc(opts, "Telescope Resume Last Operation")
)
keymap(
    "n",
    "<leader>sg",
    ":Telescope grep_string search=<cr>",
    merge_desc(opts, "Telescope Search Globally")
)
-- keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], opts)
-- keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], opts)
-- keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], opts)

-- Undo tree toggle
keymap("n", "<Leader>u", "<Cmd>UndotreeToggle<CR>", opts)

keymap("n", "<Leader>li", ":LspInfo<CR>", opts)
keymap("n", "<Leader>ll", ":LspLog<CR>", opts)
keymap("n", "<Leader>lr", ":LspRestart<CR>", opts)

-- Easier window switching with leader + Number
-- Creates mappings like this: km.set("n", "<Leader>2", "2<C-W>w", { desc = "Move to Window 2" })
for i = 1, 6 do
    local lhs = "<Leader>" .. i
    local rhs = i .. "<C-W>w"
    keymap("n", lhs, rhs, { desc = "Move to Window " .. i })
end

keymap("v", "<leader>ga", ":Gitsign stage_hunk<cr>", opts)
keymap("n", "<leader>gb", ":Gitsign blame_line<cr>", opts)
keymap("n", "[h", ":Gitsign prev_hunk<cr>", opts)
keymap("n", "]h", ":Gitsign next_hunk<cr>", opts)

keymap("n", "<leader>td", function()
    vim.cmd("TodoTelescope theme=dropdown layout_config={width=0.5}")
end, merge_desc(opts, "Show all TODOs in project."))
