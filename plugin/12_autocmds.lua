local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local utils = require("utils")

autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end })

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
    group = augroup("plugins.filtypes", {}),
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

-- aucmd("BufLeave", {
--     group = create_augroup("lspLogCleaner", { clear = true }),
--     callback = function()
--         local log_path = vim.fn.stdpath("state") .. "/lsp.log"
--         local backup_path = log_path .. ".old"

--         local stat = vim.loop.fs_stat(log_path)
--         if stat and stat.size > 1024 * 1024 then -- Limit to 1 MB
--             -- Rename the current log file
--             local succ, msg = os.rename(log_path, backup_path)
--             -- local succ, msg = os.remove(log_path)
--             if not succ then
--                 ---@diagnostic disable-next-line: param-type-mismatch
--                 vim.notify(msg, vim.log.levels.ERROR)
--                 return
--             end
--             vim.notify("Neovim log rotated", vim.log.levels.INFO)
--         end
--     end,
-- })
