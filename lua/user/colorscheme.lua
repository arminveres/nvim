-- Set colorscheme (order is important here)
local colorscheme = "gruvbox"

-- TODO: Create custom colorscheme based on:
--    https://github.com/Mofiqul/adwaita.nvim/blob/main/lua/adwaita/utils.lua
--    https://github.com/ellisonleao/gruvbox.nvim

-- Customized colors for colorschemes
local custom_colors = {
  Normal = { bg = "NONE" },
  NormalNC = { bg = "NONE" },
  PMenu = { bg = "NONE" }, -- Completion Menu
  NormalFloat = { bg = "NONE" },
  FloatBorder = { bg = "NONE" },
  CursorColumn = { bg = "#303030" },
  CursorLine = { bg = "#303030" },
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
    dim_inactive = true,
    transparent_mode = true,
    contrast = "hard", -- can be "hard" or "soft"
    -- overriding highlight groups
    overrides = custom_colors,
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
  overrides = function()
    return custom_colors
  end,
})

-- setting the colorscheme
local colorscheme_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not colorscheme_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
end
