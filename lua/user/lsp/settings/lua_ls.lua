return {
  settings = {
    Lua = {
      runtime = {
        -- LuaJIT in the case of Neovim
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        -- globals = { "vim", "packer_plugins", "awesome", "client", "root", "use" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
