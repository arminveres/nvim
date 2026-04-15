vim.o.ignorecase = true
vim.o.smartcase = true --Case insensitive searching UNLESS /C or capital in search
vim.o.smarttab = true
vim.o.hlsearch = true  -- toggle off until next search w/ <BS>
vim.o.backup = true
vim.o.writebackup = true
vim.o.breakindent = true
vim.o.inccommand = "nosplit"
vim.o.mouse = "a"
vim.o.hidden = true  --Do not save when switching buffers (note: this is now a default on master)
vim.o.scrolloff = 10 -- keeps x lines of context, scrolls otherwise

vim.o.expandtab = true
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.equalalways = true

--.o.ons to make the cursor better findable
vim.o.cursorline = true
vim.o.cursorcolumn = true

-- windows-local.o.ons
vim.o.relativenumber = true
vim.o.number = true
vim.o.colorcolumn = "100,120"
vim.o.wrap = true
vim.o.textwidth = 100
vim.o.clipboard = "unnamedplus"

vim.o.undofile = true --Save undo history

--Decrease update time
vim.o.updatetime = 250
vim.o.signcolumn = "yes"

vim.o.termguicolors = true

vim.o.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience

vim.o.list = true
-- vim.o.listchars:append("space:⋅")
-- vim.o.listchars:append("eol:↴")

-- activate spellcheck with <F11>
vim.o.spelllang = "en_us"
vim.o.wrapscan = true

-- vim.o.pumblend = 15 -- blend popup
-- vim.o.winblend = 15

vim.o.cmdheight = 1
-- configure ripgrep as grep program if available
if vim.fn.executable("rg") then
    vim.o.grepprg = "rg --no-heading --vimgrep"
    vim.o.grepformat = "%f:%l:%c:%m"
end

-- Windows specific.o.ons
if vim.fn.has("win32") == 1 then
    --[[
    vim.o.shell = "bash.exe"
    vim.o.shellcmdflag = "--login -c" -- ignore '-i' for now
    vim.o.shellxquote = ""
    ]]
    vim.o.shell = "pwsh"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.o.shellquote = [[\"]]
    vim.o.shellxquote = ""

    vim.o.undodir = os.getenv("LOCALAPPDATA") .. "/Temp/nvim/undo//"
    vim.o.backupdir = os.getenv("LOCALAPPDATA") .. "/Temp/nvim/backup//"
else
    vim.o.shell = "/usr/bin/env zsh"
    vim.o.shellcmdflag = "-c"

    vim.o.undodir = os.getenv("XDG_CACHE_HOME") .. "/nvim/undo//"
    vim.o.backupdir = os.getenv("XDG_CACHE_HOME") .. "/nvim/backup//"
end

vim.o.guifont = "Mononoki Nerd Font Propo:h11.5"

vim.g.netrw_keepdir = 0
vim.o.laststatus = 3

vim.o.linespace = 0 -- adjust for lineheight
vim.o.exrc = true

vim.o.winborder="single"

-- vim.o.fixeol = false -- stop adding automatic newline, relevant for DOS files
