return {
    enabled = false, -- superceded by Snacks.picker
    "mbbill/undotree",
    lazy = false,
    cmd = "UndotreeToggle",
    keys = {
        { "<Leader>u", "<Cmd>UndotreeToggle<CR>", desc = "Toggle the [u]ndo tree" },
    },
}
