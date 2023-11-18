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
}

-- NEOVIDE specific settings
if vim.g.neovide then
    vim.opt.guifont = fonts[1]
    vim.opt.title = true
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
    vim.g.neovide_frame_rate = 60
    vim.g.neovide_frame_rate_idle = 60
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_no_idle = true

    -- Other GUI options, e.g., nvim-Qt or Goneovim
else
    vim.opt.guifont = fonts[2]
    vim.keymap.set("i", "<S-Insert>", "<C-R>+", opts)
end
