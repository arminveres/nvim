return {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "csproj", "sln" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        picker = "snacks",
        notifications = { handler = false },
    },
}
