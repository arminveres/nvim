local gs_opts = {
    -- current_line_blame_opts = { ignore_whitespace = true, },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
            if vim.wo.diff then return "]h" end
            vim.schedule(gs.next_hunk)
            return "<Ignore>"
        end, { expr = true, desc = "Next Git [H]unk" })

        map("n", "[h", function()
            if vim.wo.diff then return "[h" end
            vim.schedule(gs.prev_hunk)
            return "<Ignore>"
        end, { expr = true, desc = "Previous Git [H]unk" })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "GitSigns [h]unk [s]tage" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "GitSigns [h]unk [r]eset" })
        map(
            "v",
            "<leader>hs",
            function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            { desc = "GitSigns [h]unk [s]tage" }
        )
        map(
            "v",
            "<leader>hr",
            function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            { desc = "GitSigns [h]unk [r]eset" }
        )
        map("n", "<leader>hS", gs.stage_buffer, { desc = "GitSigns [h]unk (buffer) [S]tage" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "GitSigns [h]unk [u]ndo" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "GitSigns [h]unk (buffer) [R]eset" })
        map("n", "<leader>hp", gs.preview_hunk)
        map(
            "n",
            "<leader>hb",
            function() gs.blame_line({ full = true }) end,
            { desc = "GitSigns [h]unk [b]lame" }
        )
        map(
            "n",
            "<leader>tb",
            gs.toggle_current_line_blame,
            { desc = "GitSigns [t]oggle line [b]lame" }
        )
        map("n", "<leader>hd", gs.diffthis, { desc = "GitSigns diffthis" })
        map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "GitSigns diffthis ~" })
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
