-- TODO(aver): xml currently kind of messes up to autorename
return {
    "windwp/nvim-ts-autotag",
    opts = {},
    -- TODO(aver): find nicer way to load on filetypes
    ft = { "xml", "http", "xaml" },
}
