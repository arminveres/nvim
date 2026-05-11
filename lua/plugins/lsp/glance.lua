return {
    "dnlhc/glance.nvim",
    -- cmd = "Glance",
    keys = {
        { "gR", function() vim.cmd.Glance("references") end, desc = "Glance references" },
    },
}
