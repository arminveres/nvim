local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("utils")

-- added from :h vim.hl
autocmd(
    { "TextYankPost", "TextPutPost" },
    { callback = function() vim.hl.hl_op({ higroup = "Todo", timeout = 150 }) end }
)

-- always only show tabline when multiple tabs exist
autocmd("TabClosed", { callback = function() vim.o.showtabline = 1 end })

autocmd("BufWritePre", {
    group = augroup("plugins.AutoCreateDir", {}),
    callback = function(event)
        local file = event.match
        -- Ignore creation of oil:// directories, which get created on each save in an Oil.nvim buffer.
        if file:match("^oil://") then return end
        local dir = vim.fn.fnamemodify(file, ":p:h")
        if vim.fn.isdirectory(dir) == 1 then return end
        vim.fn.mkdir(dir, "p")
    end,
})

autocmd({ "BufEnter", "LspAttach" }, {
    group = augroup("CustomRooter", { clear = true }),
    callback = function(ev) utils.root_project(ev.buf, true) end,
})

-- Close certain filetypes with q
-- Note: 'man' is excluded because Neovim has built-in q handling for man pages
autocmd("FileType", {
    group = augroup("plugins.CloseWithQ", {}),
    pattern = {
        "checkhealth",
        "git",
        "gitsigns-blame",
        "help",
        "lspinfo",
        "notify",
        "qf",
        "startuptime",
        "outputpanel",
        "nvim-undotree",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", function()
            local ok = pcall(vim.cmd.bdelete, { bang = true })
            if not ok then vim.cmd.quit() end
        end, { buffer = event.buf, silent = true, desc = "Close buffer" })
    end,
})

-- systemd is not always registered, so set a pattern of filestypes for it, which auto starts
-- systemd_lsp.
autocmd("BufEnter", {
    group = augroup("plugins.filetypes", {}),
    pattern = {
        -- systemd unit files
        "*.service",
        "*.socket",
        "*.timer",
        "*.mount",
        "*.automount",
        "*.swap",
        "*.target",
        "*.path",
        "*.slice",
        "*.scope",
        "*.device",
        -- Podman Quadlet files
        "*.container",
        "*.volume",
        "*.network",
        "*.kube",
        "*.pod",
        "*.build",
        "*.image",
    },
    callback = function() vim.bo.filetype = "systemd" end,
})

autocmd("FileType", {
    group = augroup("plugins.colorcolumn", {}),
    pattern = { "oil", "noice", "qf", "lspinfo" },
    callback = function() vim.opt.colorcolumn = "" end,
})

-- trim the lsp log file so it doesn't grow unbounded
autocmd("VimLeavePre", {
    group = augroup("plugins.LspLogCleaner", {}),
    callback = function()
        local path = vim.lsp.log.get_filename()
        local max = 1024 * 256 -- in Kilobytes
        local f = io.open(path, "rb")
        if not f then return end
        local size = f:seek("end")
        if size <= max then
            f:close()
            return
        end
        f:seek("set", size - max)
        local tail = f:read("*a")
        f:close()
        local out = io.open(path, "wb")
        if not out then return end
        out:write(tail)
        out:close()
    end,
})
