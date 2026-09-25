return {
    settings = {
        yaml = {
            -- disable formatting, handled by prettier
            format = { enable = false },
            schemas = {
                -- Azure Pipelines YAML, merged with installed marketplace extension
                -- tasks (e.g. jfrog) so `task: <Name>@<Version>` autocompletes.
                -- Regenerate via schemas/gen-azure-pipelines-schema.py after a
                -- task.json changes or a new extension is added.
                ["file://" .. vim.fn.stdpath("config") .. "/schemas/azure-pipelines-jfrog.schema.json"] = {
                    "azure-pipelines.yml",
                    "azure-pipelines/*.yml",
                    "**/*-pipeline.yml",
                    "**/templates/*.yml",
                },
            },
        },
    },
}
