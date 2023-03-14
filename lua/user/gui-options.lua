local opts = { noremap = true, silent = true }
local fonts = {
  "Iosevka Term:h10",
  "JetBrainsMono Nerd Font:h10",
  "Tamzen:h12",
  "TerminessTTF Nerd Font Mono:h11.5",
}

if vim.g.neovide then -- neovide specific settings
  vim.opt.guifont = fonts[1]
  vim.keymap.set("i", "<S-Insert>", "<C-R>+", opts)

  vim.g.neovide_transparency = 0.8
  vim.g.neovide_frame_rate = 60
  vim.g.neovide_frame_rate_idle = 60
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_no_idle = true
elseif vim.g.GuiLoaded then -- nvim-qt
  -- Nvim-qt needs this kind of notation
  vim.opt.guifont = { "Iosevka NFM:h11" }
  vim.keymap.set("i", "<S-Insert>", "<C-R>+", opts)
else
  vim.opt.guifont = { "Iosevka NFM:h11" }
  vim.keymap.set("i", "<S-Insert>", "<C-R>+", opts)
end

if vim.fn.has("win32") == 1 then -- Windows specific options
  vim.g.grayout_libclang_path = "C:\\Program Files\\LLVM\\bin"
  vim.opt.shell = "C:/Programme/Git/bin/bash.exe"
  vim.opt.shellcmdflag = "--login -c" -- ignore '-i' for now
  vim.opt.shellxquote = ""
end
