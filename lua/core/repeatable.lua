-- Repeatable.nvim
--
-- Repeat last bracket motion with ; / ,
-- Automatically wraps any ]x / [x mapping to be repeatable
--
-- Disclaimer: fully AI generated with Claude Opus 4.5
--

local M = {}
M._last = nil
M._last_rev = nil

local function execute(keys, noremap)
    local k = vim.api.nvim_replace_termcodes(keys, true, false, true)
    -- "n" = noremap (don't trigger mappings), "m" = remap (trigger mappings)
    local mode = noremap and "n" or "m"
    vim.api.nvim_feedkeys(k, mode, false)
end

-- Get the original mapping's rhs (what it executes)
local function get_original_rhs(mode, lhs)
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
        if map.lhs == lhs then return map.rhs or map.callback, false end
    end
    -- Also check buffer-local mappings
    local ok, buf_maps = pcall(vim.api.nvim_buf_get_keymap, 0, mode)
    if ok then
        for _, map in ipairs(buf_maps) do
            if map.lhs == lhs then return map.rhs or map.callback, false end
        end
    end
    -- No mapping found - it's a native motion
    return nil, true
end

-- Execute an action (rhs = string/function, is_native = use noremap)
local function execute_action(rhs, is_native)
    if type(rhs) == "function" then
        rhs()
    elseif type(rhs) == "string" then
        execute(rhs, is_native)
    end
end

-- Wrap a bracket mapping pair to make it repeatable
-- This intercepts ]x and [x, stores the action, then executes the original
function M.wrap_pair(suffix)
    local forward_lhs = "]" .. suffix
    local backward_lhs = "[" .. suffix

    -- Defer to allow other plugins to set up their mappings first
    vim.defer_fn(function()
        local forward_rhs, forward_native = get_original_rhs("n", forward_lhs)
        local backward_rhs, backward_native = get_original_rhs("n", backward_lhs)

        -- If no mapping found, fall back to the raw keys (for native motions like ]s)
        if not forward_rhs then forward_rhs = forward_lhs end
        if not backward_rhs then backward_rhs = backward_lhs end

        vim.keymap.set("n", forward_lhs, function()
            M._last = { rhs = forward_rhs, native = forward_native }
            M._last_rev = { rhs = backward_rhs, native = backward_native }
            execute_action(forward_rhs, forward_native)
        end, { silent = true, desc = "Repeatable " .. forward_lhs })

        vim.keymap.set("n", backward_lhs, function()
            M._last = { rhs = backward_rhs, native = backward_native }
            M._last_rev = { rhs = forward_rhs, native = forward_native }
            execute_action(backward_rhs, backward_native)
        end, { silent = true, desc = "Repeatable " .. backward_lhs })
    end, 100)
end

-- Repeat last / reverse
vim.keymap.set("n", ";", function()
    if M._last then
        execute_action(M._last.rhs, M._last.native)
    else
        execute_action(";", true)
    end
end, { silent = true, desc = "Repeat last bracket motion" })

vim.keymap.set("n", ",", function()
    if M._last_rev then
        execute_action(M._last_rev.rhs, M._last_rev.native)
    else
        execute_action(",", true)
    end
end, { silent = true, desc = "Reverse last bracket motion" })

-- Wrap common bracket mappings
-- Add any suffix you want to make repeatable
local pairs_to_wrap = {
    "q", -- quickfix list
    "l", -- loclist
    "b", -- Buffer
    "a", -- Files
    "s", -- spelling
    "n", -- conflict marker
    "f", -- files, open
    -- "t",
    -- " ", 
    "d", -- vim.diagnostics
    "e", -- vim.diagnostics, errors
}
for _, suffix in ipairs(pairs_to_wrap) do
    M.wrap_pair(suffix)
end

return M
