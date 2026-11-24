-- run `:TSInstall d2` once after install, then restart (see the project README)
return {
    "ravsii/tree-sitter-d2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = "*",
    build = "make nvim-install",
}
