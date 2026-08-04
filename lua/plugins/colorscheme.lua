local function gruvbox_init()
    local palette = require("gruvbox").palette
    -- Set border style for this theme
    vim.o.winborder = "solid"

    -- palette.dark0 = "#0F0F0F"
    -- palette.dark1 = "#1F1F1F"
    -- palette.dark2 = "#2F2F2F"

    -- palette.dark0 = "#282828"
    -- palette.dark1 = "#3c3836"
    -- palette.dark2 = "#504945"
    -- palette.dark3 = "#665c54"

    -- JDH palette, from subdued terminal colors, e.g., tmux without 256color setup, but I like them xD
    palette.dark0 = "#222222"
    palette.dark1 = "#333333"
    palette.dark2 = "#444444"
    palette.bright_red = "#ff5f5f"
    -- palette.bright_green = "#afaf00"
    -- palette.bright_yellow = "#ffa001"
    -- palette.bright_blue = "#87af87"
    -- palette.bright_purple = "#d787af"
    -- palette.bright_aqua = "#87af87"
    -- palette.bright_orange = "#ff8700"

    -- palette.bright_red = "#cc241d"
    -- palette.bright_green = "#98971a"
    -- palette.bright_yellow = "#d79921"
    -- palette.bright_blue = "#458588"
    -- palette.bright_purple = "#b16286"
    -- palette.bright_aqua = "#689d6a"
    -- palette.bright_orange = "#d65d0e"
    local gruvbox_overrides = {
        -- ========================================================================================
        -- LSP
        -- ========================================================================================
        String = { fg = "#eb9664" }, -- #eb9664, #c89664

        -- ["@lsp.type.method.c"] = { link = "GruvboxOrangeBold" },
        -- ["@lsp.type.method.cpp"] = { link = "GruvboxOrangeBold" },
        LspInlayHint = { fg = "#919191", italic = true, bold = true },

        LspReferenceText = { fg = palette.bright_yellow, bg = palette.dark2 },
        LspReferenceRead = { link = "LspReferenceText" },
        LspReferenceWrite = { link = "LspReferenceText" },

        -- These highlights are special for undefined macros
        ["@lsp.type.comment.c"] = { fg = "#91a573", bg = "#785032", italic = true },
        ["@lsp.type.comment.cpp"] = { fg = "#91a573", bg = "#785032", italic = true },
        -- Define = { link = "GruvboxPurple" },
        Macro = { link = "GruvboxPurple" },

        -- ========================================================================================
        -- Git Diff
        -- ========================================================================================
        -- DiffAdd = { bold = true, reverse = false, fg = "", bg = "#2a4333" },
        -- DiffChange = { bold = true, reverse = false, fg = "", bg = "#333841" },
        -- DiffDelete = { bold = true, reverse = false, fg = "#442d30", bg = "#442d30" },
        -- DiffText = { bold = true, reverse = false, fg = "", bg = "#213352" },
        -- GitSignsCurrentLineBlame = { link = "GruvboxFg3" },

        -- ========================================================================================
        -- Statusline and columnns
        -- ========================================================================================
        Folded = { fg = palette.bright_orange, bg = palette.dark2, italic = true },
        SignColumn = { link = "GruvboxBg0" },
        FoldColumn = { fg = palette.bright_orange, bg = palette.dark0 },
        StatusLine = { fg = palette.light0, bg = palette.dark1 },
        StatusLineNC = { fg = palette.dark1, bg = palette.dark1 },
        CursorLineNr = { fg = palette.bright_yellow, bg = "" },

        GruvboxOrangeSign = { fg = palette.bright_orange, bg = nil },
        GruvboxYellowSign = { fg = palette.bright_yellow, bg = nil },
        GruvboxAquaSign = { fg = palette.bright_aqua },
        GruvboxGreenSign = { fg = palette.bright_green },
        GruvboxRedSign = { fg = palette.bright_red, bg = nil },
        GruvboxBlueSign = { fg = palette.bright_blue },

        -- ========================================================================================
        -- Markdown highlights
        -- ========================================================================================

        -- MeanderingProgrammer/markdown.nvim
        RenderMarkdownH3Bg = { bg = "#442d30" },
        RenderMarkdownH4Bg = { bg = "#442d30" },
        RenderMarkdownH5Bg = { bg = "#442d30" },

        NonText = { link = "GruvboxBg3" },
    }

    if vim.o.winborder == "solid" then
        gruvbox_overrides = require("utils").merge(gruvbox_overrides, {
            NormalFloat = { fg = palette.light1, bg = palette.dark1 },
            SnacksInputNormal = { link = "NormalFloat" },
            SnacksInputBorder = { link = "NormalFloat" },
            SnacksPicker = { link = "NormalFloat" },
            SnacksPickerPreview = { bg = palette.dark2 },
            SnacksPickerCursorLine = { bg = palette.dark0 },
            SnacksPickerListCursorLine = { bg = palette.dark0 },

            GlanceListNormal = { fg = palette.light1, bg = palette.dark2 },
            GlancePreviewNormal = { fg = palette.light1, bg = palette.dark1 },
        })
    end

    require("gruvbox").setup({
        transparent_mode = false,
        dim_inactive = false, -- dim inactive window
        -- contrast = "hard", -- can be "hard" or "soft"
        -- overriding highlight groups through palette itself
        -- palette_overrides = { },
        overrides = gruvbox_overrides,
        palette_overrides = palette,
        -- invert_selection = true,
    })
end

local transparency_file_path = vim.fn.has("win32") == 1
    and os.getenv("LOCALAPPDATA") .. "/nvim-data/.gruvbox_transparency"
    or os.getenv("XDG_STATE_HOME") .. "/nvim/.gruvbox_transparency"

--- @brief loads the transparency from the state file into the options
--- @param do_toggle boolean Whether to toggle transparency or not
local function load_transparency(do_toggle)
    local is_transparent = false
    local read_file = io.open(transparency_file_path, "r")
    if read_file then
        is_transparent = read_file:read("*a") == "true"
        read_file:close()
    end

    if do_toggle then is_transparent = not is_transparent end

    local write_file = io.open(transparency_file_path, "w")
    if not write_file then
        vim.notify("failed to write transparency file")
        return
    end
    write_file:write(tostring(is_transparent))
    write_file:close()

    local gruvbox_options = require("gruvbox").config
    gruvbox_options.transparent_mode = is_transparent
end

local function toggle_transparency()
    load_transparency(true)
    -- require("gruvbox").setup(gruvbox_options)
    vim.cmd.colorscheme("gruvbox")
end

return {
    { -- colorschemes TODO: just write my own colorscheme based on gruvbox...
        "ellisonleao/gruvbox.nvim",
        keys = {
            {
                "<leader>cot",
                toggle_transparency,
                desc = "Toggle background transparency in gruvbox",
            },
        },
        init = function()
            gruvbox_init()
            if not vim.g.neovide then
                -- skip transparency for neovide, messes with colors
                load_transparency(false)
            end
            vim.cmd.colorscheme("gruvbox")
        end,
    },
    {
        "wtfox/jellybeans.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
}
