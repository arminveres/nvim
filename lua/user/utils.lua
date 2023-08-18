local M = {}

-- @brief Merge two tables through vim api
function M.merge(table1, table2)
    return vim.tbl_deep_extend("force", table1, table2)
end

-- @brief Merge a description into the options
function M.merge_desc(opts, description)
    return M.merge(opts, { desc = description })
end

return M
