local M = {}

-- @brief Returns the number of processing cores for clangd to use, default is 4
local nproc = function()
    local procn = tonumber(vim.fn.system("nproc"))
    if procn then
        return procn
    end
    return 10
end

M.server_opts = {
    cmd = {
        "clangd",
        "--background-index",
        "--header-insertion=iwyu", -- never
        "--clang-tidy",
        "-j=" .. nproc(),
        "--header-insertion-decorators",
        "--all-scopes-completion",
        "--pch-storage=memory",
        "--offset-encoding=utf-16",
    },
}

M.extensions = {}

return M
