local opts = { noremap = true, silent = true }
local fonts = {
  "Iosevka Term:h10",
  "JetBrainsMono Nerd Font:h10.5",
  "TamzenForPowerline:h14",
  "TerminessTTF Nerd Font Mono:h11.5",
  "DinaRemasterII:h12",
  "UbuntuMono Nerd Font Mono:h12",
  --windows fonts
  "UbuntuMono NFM:h12",
  "Hack NFM:h9",
  "NotoMono NFM:h10",
  "MesloLGSDZ NFM:h10",
}

-- NEOVIDE specific settings
if vim.g.neovide then
  vim.opt.guifont = fonts[2]
  vim.opt.title = true
  vim.opt.titlestring = "Neovide"
  -- vim.cmd([[:auto BufEnter * let &titlestring = expand("%:p")]])

  vim.keymap.set("i", "<S-Insert>", "<C-R>+", opts)
  -- set ctrl-v to paste in insert mode
  vim.keymap.set("i", "<C-v>", "<C-R>+", opts)


  vim.g.neovide_transparency = 0.95
  vim.g.neovide_frame_rate = 60
  vim.g.neovide_frame_rate_idle = 60
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_no_idle = true

  -- Other GUI options, e.g., nvim-Qt or Goneovim
elseif vim.g.GuiLoaded then
  vim.opt.guifont = fonts[1]
  vim.keymap.set("i", "<S-Insert>", "<C-R>+", opts)
end

-- Windows specific options
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "C:/Programme/Git/bin/bash.exe"
  vim.opt.shellcmdflag = "--login -c" -- ignore '-i' for now
  vim.opt.shellxquote = ""
end
