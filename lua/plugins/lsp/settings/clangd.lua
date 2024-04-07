local M = {}

-- @brief Returns the number of processing cores for clangd to use, default is 4
local nproc = function()
    local procn = tonumber(vim.fn.system("nproc"))
    if procn == nil then
        return 4
    else
        return procn
    end
end

-- TODO: find a way to use gcc for c files and g++ for cpp files, as otherwise the diagnostics are not correct
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
        "--query-driver=/opt/gcc-arm-none-eabi/bin/arm-none-eabi-g++",
    },
}

M.extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = true,
    -- These apply to the default ClangdSetInlayHints command
}

return M
