-- reenable when wrapping works: https://github.com/saghen/blink.pairs/pull/67
return {
    "saghen/blink.pairs",
    version = "*", -- (recommended) only required with prebuilt binaries

    -- download prebuilt binaries from github releases
    -- dependencies = "saghen/blink.download",
    -- OR build from source, requires nightly:
    -- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    build = "nix run .#build-plugin",

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {},
}
