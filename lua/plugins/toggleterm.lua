local function toggleterm_setup()
    require("toggleterm").setup({
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            elseif term.direction == "tab" then
                return 20
            end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "vertical",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    })

    function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
        vim.keymap.set("t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
        vim.keymap.set("t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
        vim.keymap.set("t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
        -- vim.keymap.set(
        --     't',
        --     '<esc>',
        --     '<C-\\><C-N>',
        --     { desc = 'Exit to normal mode in terminal' }
        -- )
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

    local Terminal = require("toggleterm.terminal").Terminal

    -- TODO(aver): Find a nicer way to handle all these instantiations, such as a factory for the
    -- final command
    local gitui = Terminal:new({ cmd = "gitui", hidden = true, direction = "float" })
    function _GITUI_TOGGLE()
        gitui:toggle()
    end

    local lg = Terminal:new({
        cmd = "pushd $(realpath .);lazygit;popd", -- WARN: Necessary to add realpath. Also using alias from zsh does not work
        hidden = true,
        direction = "float",
    })
    function _LAZYGIT_TOGGLE()
        lg:toggle()
    end

    local ld = Terminal:new({ cmd = "lazydocker", hidden = true, direction = "float" })
    function _LAZYDOCKER_TOGGLE()
        ld:toggle()
    end

    local ncdu = Terminal:new({ cmd = "ncdu --color dark", hidden = true })
    function _NCDU_TOGGLE()
        ncdu:toggle()
    end

    local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float" })
    function _HTOP_TOGGLE()
        htop:toggle()
    end

    local ranger = Terminal:new({ cmd = "ranger", hidden = true, direction = "float" })
    function _RANGER_TOGGLE()
        ranger:toggle()
    end
end

---@param func function
---@param cmd string
local function tmux_wrapper(func, cmd)
    if vim.fn.exists("$TMUX") then
        vim.system({ "tmux", "new-window", cmd })
    else
        func()
    end
end

return {
    enabled = false,
    "akinsho/toggleterm.nvim", -- custom terminal for neovim
    keys = {
        {
            [[<c-\>j]],
            function()
                vim.cmd("ToggleTerm direction=horizontal")
            end,
            mode = "n",
            desc = "Open Toggleterm in horizontal window.",
        },
        {
            [[<c-\>l]],
            function()
                vim.cmd("ToggleTerm direction=vertical")
            end,
            mode = "n",
            desc = "Open Toggleterm in vertical window.",
        },
        {
            [[<c-\>k]],
            function()
                vim.cmd("ToggleTerm direction=tab")
            end,
            mode = "n",
            desc = "Open Toggleterm in Tab.",
        },

        {
            "<leader>gu",
            function()
                tmux_wrapper(_GITUI_TOGGLE, "gitui")
            end,
            mode = "n",
            desc = "Toggle Gitui",
        },
        {
            "<leader>ld",
            function()
                tmux_wrapper(_LAZYDOCKER_TOGGLE, "lazydocker")
            end,
            mode = "n",
            desc = "Toggle LazyDocker",
        },
        {
            "<leader>lg",
            function()
                tmux_wrapper(_LAZYGIT_TOGGLE, "lazygit")
            end,
            mode = "n",
            desc = "Toggle LazyGit",
        },
        {
            "<leader>gr",
            function()
                tmux_wrapper(_RANGER_TOGGLE(), "ranger")
            end,
            mode = "n",
            desc = "Toggle Ranger",
        },
    },
    config = toggleterm_setup,
    dependencies = { "willothy/flatten.nvim" },
}
