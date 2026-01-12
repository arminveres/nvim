vim.keymap.set(
    "n",
    "gsh",
    "<cmd>LspClangdSwitchSourceHeader<cr>",
    { desc = "Switch to source or header" }
)

---@return number procn The number of processing cores for clangd to use.
local function nproc()
    local procn = tonumber(vim.fn.system("nproc"))
    if procn then return procn end
    return 10
end

local root_markers = {
    "compile_commands.json",
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_flags.txt",
    "Makefile",
    "configure.ac",
    ".git",
}

local function get_root()
    local path = vim.api.nvim_buf_get_name(0)

    if path == "" then return nil end

    -- Find git root first, which will be a directory at the topmost level.
    local git_dir = vim.fs.find(".git", {
        path = path,
        upward = true,
        type = "directory",
    })[1]
    if git_dir then return vim.fs.dirname(git_dir) end

    -- Fallback to the other root_markers if no git root is found
    for _, marker in ipairs(root_markers) do
        local found = vim.fs.find(marker, {
            path = path,
            upward = true,
        })[1]
        if found then return vim.fs.dirname(found) end
    end

    return vim.fs.dirname(path)
end

local command_template = {
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

return {
    cmd = command_template,
    -- Custom root_dir function to always use topmost git root
    root_dir = get_root(),
}
