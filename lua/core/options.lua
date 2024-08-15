vim.opt.ignorecase = true
vim.opt.smartcase = true --Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.hlsearch = true -- toggle off until next search w/ <BS>
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.breakindent = true
vim.opt.inccommand = "nosplit"
vim.opt.mouse = "a"
vim.opt.hidden = true --Do not save when switching buffers (note: this is now a default on master)
vim.opt.scrolloff = 10 -- keeps x lines of context, scrolls otherwise

vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.equalalways = true

-- options to make the cursor better findable
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- windows-local options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.colorcolumn = "100,120"
vim.opt.wrap = true
vim.opt.textwidth = 100
vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true --Save undo history
vim.opt.undodir = os.getenv("XDG_CACHE_HOME") .. "/nvim/undo//"
vim.opt.backupdir = os.getenv("XDG_CACHE_HOME") .. "/nvim/backup//"

--Decrease update time
vim.opt.updatetime = 250
-- vim.opt.signcolumn = "yes"

vim.opt.termguicolors = true

vim.opt.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience

vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")

-- activate spellcheck with <F11>
vim.opt.spelllang = "en_us"

vim.opt.pumblend = 15 -- blend popup
vim.opt.winblend = 15

vim.opt.cmdheight = 1
-- configure ripgrep as grep program if available
if vim.fn.executable("rg") then
    vim.o.grepprg = "rg --no-heading --vimgrep"
    vim.o.grepformat = "%f:%l:%c:%m"
end

-- Windows specific options
if vim.fn.has("win32") == 1 then
    vim.opt.shell = [[C:/Programme/Git/bin/bash.exe]]
    vim.opt.shellcmdflag = "--login -c" -- ignore '-i' for now
    vim.opt.shellxquote = ""
else
    vim.opt.shell = "/usr/bin/env zsh -i"
end

vim.g.netrw_keepdir = 0
vim.opt.laststatus = 3

vim.opt.guifont = "IosevkaTerm Nerd Font Propo:h12"
