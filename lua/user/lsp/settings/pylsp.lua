return {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "W391", "E402" },
          maxLineLength = 100,
        },
        rope_completion = {
          enabled = true,
        },
      },
    },
  },
}
