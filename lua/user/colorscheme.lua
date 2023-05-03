-- Set colorscheme (order is important here)
local colorscheme = "gruvbox"

-- TODO: Create custom colorscheme based on:
--    https://github.com/Mofiqul/adwaita.nvim/blob/main/lua/adwaita/utils.lua
--    https://github.com/ellisonleao/gruvbox.nvim

-- Customized colors for colorschemes
local custom_colors = {
  -- Normal = { bg = "NONE" },
  -- NormalNC = { bg = "NONE" },
  -- PMenu = { bg = "NONE" }, -- Completion Menu
  -- NormalFloat = { bg = "NONE" },
  -- FloatBorder = { bg = "NONE" },
  CursorColumn = { bg = "#303030" },
  CursorLine = { bg = "#303030" },
  SagaNormal = { bg = "#303030" },
  -- TODO: (aver) change string color, green starts to get annoying
  -- String = { link = "GruvboxOrangeBold" },
  -- String = { fg = "#af5a32" },
  -- Comment = { fg = "#79740e" },
  -- Function = { fg = "#af3a03" }
}

-- gruvbox settings
local gruvbox_ok, gruvbox = pcall(require, "gruvbox")
if not gruvbox_ok then
  vim.notify("gruvbox not ok")
else
  gruvbox.setup({
    undercurl = true,
    underline = true,
    bold = true,
    -- italic = {}, -- will make italic comments and special strings
    strikethrough = true,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = true,
    dim_inactive = false,
    transparent_mode = true,
    contrast = "hard", -- can be "hard" or "soft"
    -- overriding highlight groups
    palette_overrides = {
      dark0_hard = "#101010"
    },
    overrides = {
      String = { fg = "#eb9664" }, -- #eb9664, #c89664
      Comment = { fg = "#919191", italic = true, bold = false },
      -- These highlights are special for undefined macros
      ["@lsp.type.comment.c"] = { fg = "#91a573", bg = "#785032" },
      ["@lsp.type.comment.cpp"] = { fg = "#91a573", bg = "#785032" },
      -- Comment = { fg = "#c89664", italic = true, bold = false },
      Define = { link = "GruvboxPurple" },
      Macro = { link = "GruvboxPurple" },
      -- new git colors
      DiffAdd = { bold = true, reverse = false, fg = "", bg = "#2a4333" },
      DiffChange = { bold = true, reverse = false, fg = "", bg = "#333841" },
      DiffDelete = { bold = true, reverse = false, fg = "#442d30", bg = "#442d30" },
      DiffText = { bold = true, reverse = false, fg = "", bg = "#213352" },
      -- fold
      Folded = { fg = "#fe8019", bg = "#3c3836", italic = true },
      FoldColumn = { fg = "#fe8019", bg = "#0E1018" },
      SignColumn = { link = "GruvboxBg0" },
      -- statusline
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
      -- LspSaga colors
      SagaNormal = { link = 'PMenu' },
      LspInlayHint = { link = 'GruvboxAqua' },
      -- LspInlayHint = { fg = '#325f5f' },
      LspInlayHints = { link = 'GruvboxAqua' }
    } --custom_colors,
  })
end

local vcs_ok, vscode = pcall(require, 'vscode')
if not vcs_ok then
  vim.notify('vscode not ok')
else
  -- local c = require('vscode.colors').get_colors()
  vscode.setup({
    -- Alternatively set style in setup
    style = 'dark',
    -- Enable transparent background
    transparent = true,
    -- Enable italic comment
    italic_comments = true,
    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,
    -- Override colors (see ./lua/vscode/colors.lua)
    -- color_overrides = {
    --   vscLineNumber = '#FFFFFF',
    -- },
    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
      -- this supports the same val table as vim.api.nvim_set_hl
      -- use colors from this colorscheme by requiring vscode.colors!
      -- Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
    }
  })
end

local kok, kanagawa = pcall(require, "kanagawa")
if not kok then
  vim.notify("kanagawa not ok")
  return
end

kanagawa.setup({
  transparent = true,
  -- overrides = function()
  --   return custom_colors
  -- end,
})

-- setting the colorscheme
local colorscheme_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not colorscheme_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
end
