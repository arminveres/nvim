local M = {}

function M.merge(table1, table2)
    return vim.tbl_deep_extend("force", table1, table2)
end

return M
