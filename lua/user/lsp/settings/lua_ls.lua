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
        library = {
          -- Make the server aware of Neovim runtime files
          -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          -- ["/usr/share/awesome/lib"] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
