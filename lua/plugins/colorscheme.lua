local gruvbox_overrides = {
    -- ========================================================================================
    -- LSP
    -- ========================================================================================
    String = { fg = "#eb9664" }, -- #eb9664, #c89664

    -- ["@lsp.type.method.c"] = { link = "GruvboxOrangeBold" },
    -- ["@lsp.type.method.cpp"] = { link = "GruvboxOrangeBold" },
    LspInlayHint = { fg = "#919191", italic = true, bold = true },

    LspReferenceText = { fg = "#FABD2F", underline = true },

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
    -- Fold
    -- ========================================================================================
    Folded = { fg = "#fe8019", bg = "#3c3836", italic = true },
    FoldColumn = { fg = "#fe8019" },
    SignColumn = { link = "GruvboxBg0" },

    -- ========================================================================================
    -- statusline and column
    -- ========================================================================================
    StatusLine = { fg = "#ffffff", bg = "#1F1F1F" },
    StatusLineNC = { fg = "#3c3836", bg = "#1F1F1F" },
    CursorLineNr = { fg = "#fabd2f", bg = "" },
    GruvboxOrangeSign = { fg = "#dfaf87", bg = "" },
    GruvboxAquaSign = { fg = "#8EC07C", bg = "" },
    GruvboxGreenSign = { fg = "#b8bb26", bg = "" },
    GruvboxRedSign = { fg = "#fb4934", bg = "" },
    GruvboxBlueSign = { fg = "#83a598", bg = "" },

    -- ========================================================================================
    -- Markdown highlights
    -- ========================================================================================

    -- MeanderingProgrammer/markdown.nvim
    RenderMarkdownH3Bg = { bg = "#442d30" },
    RenderMarkdownH4Bg = { bg = "#442d30" },
    RenderMarkdownH5Bg = { bg = "#442d30" },
}

local gruvbox_options = {
    transparent_mode = false,
    dim_inactive = false, -- dim inactive window
    -- contrast = "hard", -- can be "hard" or "soft"
    -- overriding highlight groups
    palette_overrides = {
        -- dark0 = "#0F0F0F",
        -- dark1 = "#1F1F1F"
    },
    overrides = gruvbox_overrides,
}

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
    gruvbox_options.transparent_mode = not (is_content_true and do_toggle)
    transparency:write(tostring(gruvbox_options.transparent_mode))
    transparency:close()
end

local function toggle_transparency()
    load_transparency(true)
    require("gruvbox").setup(gruvbox_options)
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
            load_transparency(false)
            require("gruvbox").setup(gruvbox_options)
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
