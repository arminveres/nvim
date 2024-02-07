local color_overrides = {
    -- ========================================================================================
    -- LSP and LspSaga colors
    -- ========================================================================================
    -- SagaNormal = { link = "PMenu" },
    FloatShadow = { link = "PMenu" },
    FloatShadowThrough = { link = "PMenu" },
    String = { fg = "#eb9664" }, -- #eb9664, #c89664
    Comment = { fg = "#919191", italic = true, bold = false },
    -- These highlights are special for undefined macros
    ["@lsp.type.comment.c"] = { fg = "#91a573", bg = "#785032" },
    ["@lsp.type.comment.cpp"] = { fg = "#91a573", bg = "#785032" },
    -- Comment = { fg = "#c89664", italic = true, bold = false },
    Define = { link = "GruvboxPurple" },
    Macro = { link = "GruvboxPurple" },

    -- ========================================================================================
    -- Git Diff
    -- ========================================================================================
    DiffAdd = { bold = true, reverse = false, fg = "", bg = "#2a4333" },
    DiffChange = { bold = true, reverse = false, fg = "", bg = "#333841" },
    DiffDelete = { bold = true, reverse = false, fg = "#442d30", bg = "#442d30" },
    DiffText = { bold = true, reverse = false, fg = "", bg = "#213352" },
    GitSignsCurrentLineBlame = { link = "GruvboxFg3" },

    -- ========================================================================================
    -- Fold
    -- ========================================================================================
    Folded = { fg = "#fe8019", bg = "#3c3836", italic = true },
    FoldColumn = { fg = "#fe8019", bg = "#0E1018" },
    SignColumn = { link = "GruvboxBg0" },

    -- ========================================================================================
    -- statusline and column
    -- ========================================================================================
    StatusLine = { bg = "#ffffff", fg = "#0E1018" },
    StatusLineNC = { bg = "#3c3836", fg = "#0E1018" },
    CursorLineNr = { fg = "#fabd2f", bg = "" },
    GruvboxOrangeSign = { fg = "#dfaf87", bg = "" },
    GruvboxAquaSign = { fg = "#8EC07C", bg = "" },
    GruvboxGreenSign = { fg = "#b8bb26", bg = "" },
    GruvboxRedSign = { fg = "#fb4934", bg = "" },
    GruvboxBlueSign = { fg = "#83a598", bg = "" },
    WilderMenu = { fg = "#ebdbb2", bg = "" },
    WilderAccent = { fg = "#f4468f", bg = "" },

    -- ========================================================================================
    -- Markdown highlights
    -- ========================================================================================
    Headline1 = { bg = "#442d30" },
    Headline2 = { bg = "#1e2718" },
    Headline3 = { bg = "#21262d" },

    IblScope = { link = "GruvboxRedSign" },
}

local gruvbox_options = {
    transparent_mode = false,
    contrast = "hard", -- can be "hard" or "soft"
    dim_inactive = false, -- dim inactive window
    -- overriding highlight groups
    palette_overrides = {
        dark0_hard = "#141414",
    },
    overrides = color_overrides,
}

local transparency_loc = os.getenv("XDG_STATE_HOME") .. "/nvim/.gruvbox_transparency"

--- @brief returns the content of the state file
local function get_content()
    local transparency = io.open(transparency_loc, "r")
    if not transparency then
        vim.notify("failed to create file")
        return ""
    end
    return transparency:read("*a")
end

--- @brief loads the transparency from the state file into the options
--- @param do_toggle boolean Whether to toggle transparency or not
local function load_transparency(do_toggle)
    local content = get_content()

    local transparency = io.open(transparency_loc, "w+")
    if not transparency then
        vim.notify("failed to create file")
        return
    end

    if "" == content then
        if do_toggle then
            gruvbox_options.transparent_mode = not gruvbox_options.transparent_mode
        end
        transparency:write(tostring(gruvbox_options.transparent_mode))
        transparency:close()
        return
    end

    if "true" == content then
        if do_toggle then
            gruvbox_options.transparent_mode = false
        else
            gruvbox_options.transparent_mode = true
        end
    else
        if do_toggle then
            gruvbox_options.transparent_mode = true
        else
            gruvbox_options.transparent_mode = false
        end
    end

    transparency:write(tostring(gruvbox_options.transparent_mode))
    transparency:close()
end

local function toggle_transparency()
    load_transparency(true)
    require("gruvbox").setup(gruvbox_options)
    vim.cmd.colorscheme("gruvbox")
end

return { -- colorschemes TODO: just write my own colorscheme based on gruvbox...
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1001,
    keys = {
        {
            "<leader>ctt",
            toggle_transparency,
            desc = "Toggle background transparency in gruvbox",
        },
    },
    config = function()
        load_transparency(false)
        require("gruvbox").setup(gruvbox_options)
        vim.cmd.colorscheme("gruvbox")
    end,
}
