-- TODO: (aver) move non plugins into a core!
require("user.options")
require("user.gui-options") -- Needs to be loaded before the plugins, otherwise shell does not get recognized for WIN Gui
require("user.mappings") -- NOTE: could move this to bottom to make all mappings configurable there.
require("user.lazy")
require("user.lsp")
require("user.autocmds")

vim.opt.showtabline = 1 -- only show when more than one 1 tab, need to be loaded last, gets overwritten otherwise
vim.cmd([[highlight link TrailingSpaces Error | match TrailingSpaces /\s\+$/]])

-- setting the colorscheme
local colorscheme = "gruvbox"
local colorscheme_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not colorscheme_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
end
