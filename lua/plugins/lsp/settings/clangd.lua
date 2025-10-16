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
    "--query-driver=**",
}

M.server_opts = {
    cmd = M.command_template,
    root_markers = {
        "compile_commands.json",
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_flags.txt",
        "Makefile",
        "configure.ac",
        ".git",
    },
}

M.extensions = {}

return M
