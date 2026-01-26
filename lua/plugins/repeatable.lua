---@return string | function | nil callback
---@return string | nil description
local function get_original_rhs(mode, lhs)
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
        if map.lhs == lhs then return map.rhs or map.callback, map.desc end
    end
    -- Also check buffer-local mappings
    local ok, buf_maps = pcall(vim.api.nvim_buf_get_keymap, 0, mode)
    if ok then
        for _, map in ipairs(buf_maps) do
            if map.lhs == lhs then return map.rhs or map.callback, map.desc end
        end
    end
    -- No mapping found - it's a native motion
    return nil, nil
end

local pairs_to_wrap = {
    "q", -- quickfix list
    "l", -- loclist
    "b", -- Buffer
    "a", -- Files
    "n", -- conflict marker
    "f", -- files, open
    -- "s", -- spelling
    -- "t",
    -- " ",
    -- "d", -- vim.diagnostics
    -- "e", -- vim.diagnostics, errors
}
return {
    "kiyoon/repeatable-move.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
        local repeat_move = require("repeatable_move")
        for _, suffix in ipairs(pairs_to_wrap) do
            local forward_lhs = "]" .. suffix
            local backward_lhs = "[" .. suffix
            local forward_rhs, fwd_desc = get_original_rhs("n", forward_lhs)
            local backward_rhs, back_desc = get_original_rhs("n", backward_lhs)

            -- If no mapping found, fall back to the raw keys (for native motions like ]s)
            if not forward_rhs then forward_rhs = forward_lhs end
            if not backward_rhs then backward_rhs = backward_lhs end

            local next_move, prev_move =
                repeat_move.make_repeatable_move_pair(forward_rhs, backward_rhs)

            vim.keymap.set({ "n", "x", "o" }, forward_lhs, next_move, { desc = fwd_desc })
            vim.keymap.set({ "n", "x", "o" }, backward_lhs, prev_move, { desc = back_desc })
        end
    end,
}
