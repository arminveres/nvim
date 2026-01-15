local utils = require("core.utils")
local merge_desc = utils.merge_desc
local map = vim.keymap.set

-- Non recursive map map
---@type table
local opts = { noremap = true, silent = true }

-- Recurisve map
---@type table
local remopts = { noremap = false, silent = true }

-- Leader --
--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ================================================================================================
-- NeoVIM CORE
-- ================================================================================================
-- Normal Mode --
map("n", "<ESC>", "<cmd>noh<CR>", remopts) -- recursively redefine escape; disable hlsearch until next search

--Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- No arrow keys. Force yourself to use the home row
map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Y yank until the end of line  (note: this is now a default on master)
map("n", "Y", "y$", { noremap = true })

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
-- keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
-- keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
-- Only move the text, don't go into insert more
map("n", "<A-j>", "<Esc>:m .+1<CR>", opts)
map("n", "<A-k>", "<Esc>:m .-2<CR>", opts)

-- Navigate tabs
map("n", "<C-t>", ":$tabnew<CR>", opts)
map("n", "<leader>tc", ":tabclose<CR>", opts)
map("n", "<leader>to", ":tabonly<CR>", opts)
map("n", "<leader>tn", ":tabn<CR>", opts)
map("n", "<leader>tp", ":tabp<CR>", opts)
-- move current tab to previous position
map("n", "<leader>tmp", ":-tabmove<CR>", opts)
-- move current tab to next position
map("n", "<leader>tmn", ":+tabmove<CR>", opts)

-- Insert Mode --
-- Visual Mode --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("v", "p", '"_dP', opts) -- when pasting in visual, don't copy deleted word to register

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)
map("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
map("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Spell Checking --
map("n", "<F11>", ":set spell!<CR>", opts)
map("i", "<F11><C-O>", ":set spell!<CR>", opts)
-- replacing is done in insertmode <C-x>s

-- center up and down jumps
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)

-- Map Tab to go to the right if the next character is a closing pair
map("i", "<Tab>", function()
    local col = vim.fn.col(".") - 1
    local line = vim.fn.getline(".")
    local char = line:sub(col + 1, col + 1)
    if char:match("[%)%]%}%\"']%>") then
        return "<Right>"
    else
        return "<Tab>"
    end
end, { expr = true, noremap = true })

-- keymap('n', '<leader>fe', ':Lex 30<cr>', opts) -- made obsolete by oil.nvim
-- ================================================================================================
-- CLIPBOARD
-- ================================================================================================
map("n", "<leader>q", "<cmd>q<CR>", opts)
map("n", "<leader>Q", "<Cmd>qall!<CR>", opts) -- quickquit
map("n", "<leader>w", "<Cmd>w<CR>", opts) -- quick save
map("n", "<leader>W", "<Cmd>w!<CR>", opts) -- quick save
-- keymap("n", ",WQ", "<Cmd>wq!<CR>", opts) -- quick save

-- Yank to clipboard
map("v", "<leader>y", '"+y', opts)
map("n", "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+Y', remopts)
-- Paste from clipboad
map("n", "<leader>p", '"+p', opts)
map("n", "<leader>P", '"+P', opts)
--[[ keymap('v', '<leader>p', '"+p', opts) ]]
--[[ keymap('v', '<leader>P', '"+P', opts) ]]
-- delete into nirvana
-- keymap("n", "<leader>d", '"_d', opts)
map("v", "<leader>d", '"_d', opts)
-- According to thePrimeagen, the greatest map ever
map("x", "<leader>p", '"_dP', opts)

-- Easier window switching with leader + Number
-- Creates mappings like this: km.set("n", "<Leader>2", "2<C-W>w", { desc = "Move to Window 2" })
for i = 1, 6 do
    local lhs = "<Leader>" .. i
    local rhs = i .. "<C-W>w"
    map("n", lhs, rhs, { desc = "Move to Window " .. i })
end

map(
    "n",
    "<leader>cr",
    function() utils.root_project(vim.api.nvim_get_current_buf()) end,
    merge_desc(opts, "[C]hange the [r]oot of the current buffer to the project root.")
)

-- Quickfix
map("n", "<leader>xn", "<cmd>cnext<cr>", { desc = "next quickfix" })
map("n", "<leader>xp", "<cmd>cprev<cr>", { desc = "previous quickfix" })

map("n", "<leader>tl", function()
    local config = vim.diagnostic.config() or {}
    local new_value = not config.virtual_lines
    vim.diagnostic.config({ virtual_lines = new_value })
end, { desc = "[Toggle] diagnostic [l]ines" })
