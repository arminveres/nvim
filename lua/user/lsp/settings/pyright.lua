-- https://microsoft.github.io/pyright/#/configuration?id=main-configuration-options
return {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = false,
                diagnosticMode = "workspace",
            },
            single_file_support = true,
        },
    },
}
