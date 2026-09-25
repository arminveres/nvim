return {
    -- ignore formatter as we use prettier
    init_options = { provideFormatter = false },
    settings = {
        json = {
            schemas = {
                {
                    -- Azure DevOps extension task.json (e.g. jfrog-azure-devops-extension: tasks/<Task>/task.json)
                    fileMatch = { "**/tasks/*/task.json", "**/*task.json" },
                    url = "https://raw.githubusercontent.com/microsoft/azure-pipelines-task-lib/master/task.schema.json",
                },
                {
                    -- Extension manifest (vss-extension.json) at repo root
                    fileMatch = { "vss-extension.json" },
                    url = "https://json.schemastore.org/vss-extension.json",
                },
            },
        },
    },
}
