return {
    settings = {
        pylsp = {
            plugins = {
                -- rope_completion = {
                --     enabled = false,
                -- },
                -- rope_rename = {
                --     enabled = true,
                -- },
                -- pycodestyle = {
                --     ignore = { "W391", "E402", "E203", "W504" },
                --     maxLineLength = 100,
                -- },
                -- jedi_completion = {
                --     enabled = false,
                --     include_class_objects = true,
                --     include_function_objects = true,
                -- },

                -- type checker
                pylsp_mypy = { enabled = true },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                pyls_isort = { enabled = true },
                -- formatter options
                black = { enabled = true },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = {
                    enabled = true,
                    executable = "pylint",
                    args = {
                        -- messages_control = {
                        -- disable = { "missing-module-docstring", "missing-function-docstring" },
                        -- },
                    },
                },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
            },
        },
    },
}
