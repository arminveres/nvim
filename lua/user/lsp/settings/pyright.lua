return {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                -- typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
            single_file_support = true,
        },
    },
}
