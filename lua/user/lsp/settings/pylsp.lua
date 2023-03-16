return {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "W391", "E402", "E203", "W504" },
          maxLineLength = 100,
        },
        rope_completion = {
          enabled = false,
        },
        rope_rename = {
          enabled = true,
        },
        jedi_completion = {
          enabled = true,
          include_class_objects = true,
          include_function_objects = true,
        },
      },
    },
  },
}
