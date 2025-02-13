local gs_opts = {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Next Git Change" })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Previous Git Change" })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "GitSigns [h]unk [s]tage" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "GitSigns [h]unk [r]eset" })
        map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "GitSigns [h]unk [s]tage" })
        map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "GitSigns [h]unk [r]eset" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "GitSigns [h]unk (buffer) [S]tage" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "GitSigns [h]unk [u]ndo" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "GitSigns [h]unk (buffer) [R]eset" })
        map("n", "<leader>hp", gs.preview_hunk)
        map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, { desc = "GitSigns [h]unk [b]lame" })
        map(
            "n",
            "<leader>tb",
            gs.toggle_current_line_blame,
            { desc = "GitSigns [t]oggle line [b]lame" }
        )
        map("n", "<leader>hd", gs.diffthis, { desc = "GitSigns diffthis" })
        map("n", "<leader>hD", function()
            gs.diffthis("~")
        end, { desc = "GitSigns diffthis ~" })
        map("n", "<leader>td", gs.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
}

return {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    opts = gs_opts,
}
