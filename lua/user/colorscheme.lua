-- Set colorscheme (order is important here)
local colorscheme = 'gruvbox'

-- TODO: Create custom colorscheme based on:
--    https://github.com/Mofiqul/adwaita.nvim/blob/main/lua/adwaita/utils.lua
--    https://github.com/ellisonleao/gruvbox.nvim

-- Customized colors for colorschemes
local custom_colors = {
  Normal = { bg = 'NONE' },
  NormalNC = { bg = 'NONE' },
  PMenu = { bg = 'NONE' }, -- Completion Menu
  NormalFloat = { bg = 'NONE' },
  FloatBorder = { bg = 'NONE' },
  SignColumn = { bg = 'NONE' },
  WinBar = { bg = 'NONE' },
  GitSignsAdd = { bg = 'NONE' },
  GitSignsDelete = { bg = 'NONE' },
  GitSignsChange = { bg = 'NONE' },

  CursorColumn = { bg = '#303030' },
  CursorLine = { bg = '#303030' },
}

-- gruvbox settings
local gruvbox_ok, gruvbox = pcall(require, 'gruvbox')
if not gruvbox_ok then
  vim.notify('gruvbox not ok')
else
  gruvbox.setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = true, -- will make italic comments and special strings
    inverse = true, -- invert background for search, diffs, statuslines and errors
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    contrast = 'hard', -- can be "hard" or "soft"
    -- overriding highlight groups
    overrides = custom_colors,
  })
end

-- setting the colorscheme
local csm_status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not csm_status_ok then
  vim.notify('colorscheme ' .. colorscheme .. ' not found!')
end
