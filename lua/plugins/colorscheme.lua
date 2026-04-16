local function gruvbox_init()
    local palette = require("gruvbox").palette
    -- Set border style for this theme
    vim.o.winborder = "solid"

    palette.dark0 = "#0F0F0F"
    palette.dark1 = "#1F1F1F"
    palette.dark2 = "#2F2F2F"

    local gruvbox_overrides = {
        -- ========================================================================================
        -- LSP
        -- ========================================================================================
        String = { fg = "#eb9664" }, -- #eb9664, #c89664

        -- ["@lsp.type.method.c"] = { link = "GruvboxOrangeBold" },
        -- ["@lsp.type.method.cpp"] = { link = "GruvboxOrangeBold" },
        LspInlayHint = { fg = "#919191", italic = true, bold = true },

        LspReferenceText = { fg = palette.bright_yellow, underline = true },

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
        GruvboxOrangeSign = { fg = "#dfaf87", bg = "" },
        GruvboxAquaSign = { fg = palette.bright_aqua, bg = "" },
        GruvboxGreenSign = { fg = palette.bright_green, bg = "" },
        GruvboxRedSign = { fg = palette.bright_red, bg = "" },
        GruvboxBlueSign = { fg = palette.bright_blue, bg = "" },

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
            SnacksPicker = { link = "NormalFloat" },
            SnacksPickerPreview = { bg = palette.dark2 },
            SnacksPickerCursorLine = { bg = palette.dark0 },
            SnacksPickerListCursorLine = { bg = palette.dark0 },
        })
    end

    require("gruvbox").setup({
        transparent_mode = false,
        dim_inactive = false, -- dim inactive window
        -- contrast = "hard", -- can be "hard" or "soft"
        -- overriding highlight groups through palette itself
        -- palette_overrides = { },
        overrides = gruvbox_overrides,
    })
end

local transparency_loc = vim.fn.has("win32") == 1
    and os.getenv("LOCALAPPDATA") .. "/nvim-data/.gruvbox_transparency"
    or os.getenv("XDG_STATE_HOME") .. "/nvim/.gruvbox_transparency"

--- @brief loads the transparency from the state file into the options
--- @param do_toggle boolean Whether to toggle transparency or not
local function load_transparency(do_toggle)
    local transparency = io.open(transparency_loc, "r")
    local content
    if not transparency then
        vim.notify("failed to create file")
        content = ""
    else
        content = transparency:read("*a")
    end

    transparency = io.open(transparency_loc, "w+")
    if not transparency then
        vim.notify("failed to create file")
        return
    end

    local is_content_true = "true" == content
    local gruvbox_options = require("gruvbox").config
    gruvbox_options.transparent_mode = not (is_content_true and do_toggle)
    transparency:write(tostring(gruvbox_options.transparent_mode))
    transparency:close()
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
