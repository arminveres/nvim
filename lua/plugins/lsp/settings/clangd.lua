local M = {}

---@return number procn The number of processing cores for clangd to use.
local function nproc()
    local procn = tonumber(vim.fn.system("nproc"))
    if procn then return procn end
    return 10
end

M.command_template = {
    "clangd",
    "--background-index",
    "--header-insertion=iwyu", -- never
    "--clang-tidy",
    "-j=" .. nproc(),
    "--header-insertion-decorators",
    "--all-scopes-completion",
    "--pch-storage=memory",
}

M.server_opts = {
    cmd = M.command_template,
}

M.extensions = {}

return M
