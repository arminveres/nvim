-- reenable when wrapping works: https://github.com/saghen/blink.pairs/pull/67
return {
    "saghen/blink.pairs",
    version = "*", -- (recommended) only required with prebuilt binaries
    dependencies = "saghen/blink.lib",
    -- build = function() require("blink.pairs").download():pwait(60000) end,
    build = function() require('blink.pairs').build():pwait(60000) end,
    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {},
}
