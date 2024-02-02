local opts = { noremap = true, silent = true }
local fonts = {
    "MesloLGS Nerd Font Mono:h9",
    "DejaVuSansM Nerd Font Mono:h9",
    "IosevkaTerm Nerd Font Mono:h10",
    "JetBrainsMono Nerd Font Mono:h8.5",
    "UbuntuMono Nerd Font Mono:h12",
    "Hack Nerd Font Mono:h9",
    "NotoMono Nerd Font Mono:h9",
    -- Bitmap fonts
    "DinaRemasterII:h10",
    "Terminuss Nerd Font Mono:h10.5",
}

vim.opt.guifont = fonts[8]
-- vim.opt.title = true
-- NEOVIDE specific settings
if vim.g.neovide then
    -- vim.opt.titlestring = "Neovide"
    -- vim.cmd([[:auto BufEnter * let &titlestring = expand("%:p")]])

    vim.keymap.set("i", "<S-Insert>", "<C-R>+", opts)
    -- set ctrl-v to paste in insert mode
    vim.keymap.set("i", "<C-v>", "<C-R>+", opts)

    -- add padding because of rounded borders
    vim.g.neovide_padding_top = 5
    vim.g.neovide_padding_bottom = 5
    vim.g.neovide_padding_right = 5
    vim.g.neovide_padding_left = 5

    vim.g.neovide_transparency = 0.95
    vim.g.neovide_frame_rate = 160
    vim.g.neovide_frame_rate_idle = 160
    vim.g.neovide_no_idle = true
    -- vim.g.neovide_cursor_animation_length = 0
    -- vim.g.neovide_scroll_animation_length = 0
else -- Other GUI options, e.g., nvim-Qt or Goneovim
    -- set font for neovim-gtk
    vim.cmd([[call rpcnotify(1, "Gui", "Font", "DejaVuSansMono Nerd Font Mono 12")]])
end
