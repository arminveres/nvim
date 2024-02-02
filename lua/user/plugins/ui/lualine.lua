local function get_active_lsps()
    local msg = "no lsp"
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return msg
    end
    local lsps = ""
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            lsps = lsps .. client.name .. " "
        end
    end

    if lsps == "" then
        return msg
    else
        return lsps
    end
end

local function get_inactive_winbar()
    return vim.api.nvim_win_get_number(0)
end

local function get_active_winbar()
    local bar = require("lspsaga.symbol.winbar").get_bar()
    if not bar then
        return get_inactive_winbar()
    end
    return bar
end

--- @brief setups up all lualine related configurations
local function lualine_setup()
    local my_theme = require("lualine.themes.powerline")
    local gruvbox_colors = require("gruvbox").palette
    local my_colors = {
        gray1 = "#262626",
        gray2 = "#303030",
        gray4 = "#585858",
        gray5 = "#606060",
        gray7 = "#9e9e9e",
        gray8 = "#aaaaaa",
        gray10 = "#f0f0f0",
    }

    my_theme.normal = {
        a = { fg = gruvbox_colors.dark0, bg = "#d75f00", gui = "bold" },
        b = { fg = my_colors.gray10, bg = gruvbox_colors.dark1 },
        c = { fg = my_colors.gray10, bg = gruvbox_colors.dark0_hard },
    }
    my_theme.visual = {
        a = { fg = gruvbox_colors.light0, bg = gruvbox_colors.neutral_blue, gui = "bold" },
    }
    my_theme.insert = {
        a = { fg = gruvbox_colors.dark0, bg = gruvbox_colors.neutral_green, gui = "bold" },
    }
    my_theme.terminal = {
        a = { fg = gruvbox_colors.dark0, bg = gruvbox_colors.bright_aqua, gui = "bold" },
    }
    my_theme.inactive.a.fg = gruvbox_colors.light0_hard
    my_theme.inactive.b.fg = gruvbox_colors.light0_hard
    my_theme.inactive.c.fg = gruvbox_colors.light0_hard

    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = my_theme,
            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = true,
        },
        sections = {
            lualine_a = { { "mode" } },
            lualine_b = {
                { "branch", icon = { "", color = { fg = "#f34f29" } } },
                -- { "diff" },
                { "diagnostics" },
            },
            lualine_c = {
                { "%=", separator = "" },
                {
                    ---@brief Get the project root dir name
                    function()
                        return vim.fn.fnamemodify(
                            require("project_nvim.project").find_pattern_root(),
                            ":t"
                        )
                    end,
                    cond = function()
                        local capture = vim.fn.fnamemodify(
                            require("project_nvim.project").find_pattern_root(),
                            ":t"
                        )
                        return capture ~= "null" and capture ~= "v:null"
                    end,
                },
                {
                    "filename",
                    path = 0, -- 0: Just the filename, 1: Relative path, 2: Absolute path
                    file_status = true, -- Displays file status (readonly status, modified status)
                    shorting_target = 40, -- Shortens path to leave 40 spaces in the window for other components.
                },
            },
            lualine_x = {
                {
                    -- icon = "  LSP:",
                    icon = ":",
                    get_active_lsps,
                },
                "encoding",
                "fileformat",
                "filetype",
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = { get_inactive_winbar },
            lualine_c = { "filename" },
            lualine_x = { "location" },
        },

        -- TODO: (aver) add outline to lualine and then make status global again, as currently lualine hijackts outline in wibar
        -- So if winbar disabled in lspsaga, then this works, issue is, that some parts are
        -- white
        -- winbar = {
        --     lualine_a = { get_active_winbar },
        -- },
        -- inactive_winbar = {
        --     lualine_a = { get_inactive_winbar },
        -- },
    })
end

return {
    {
        "nvim-lualine/lualine.nvim", -- Fancier statusline
        config = lualine_setup,
        dependencies = { "ellisonleao/gruvbox.nvim" },
        lazy = false,
    },
}
