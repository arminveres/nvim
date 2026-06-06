-- https://nix-community.github.io/nixd/md_nixd_2docs_2configuration.html
return {
    cmd = { "nixd", "--inlay-hints", "--semantic-tokens" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = 'import (builtins.getFlake "/home/arminveres/nix-conf").inputs.nixpkgs',
            },
            formatting = { command = { "nixfmt" } },
        },
    },
}
