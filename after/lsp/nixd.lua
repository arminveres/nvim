return {
    cmd = { "nixd", "--inlay-hints", "--semantic-tokens" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = 'import (builtins.getFlake "/home/arminveres/nix-conf").inputs.nixpkgs',
            },
            formatting = { command = { "nixfmt" } },
            options = {
                nixos = {
                    expr = '(builtins.getFlake "/home/arminveres/nix-conf").nixosConfigurations.'
                        .. vim.uv.os_gethostname()
                        .. ".options",
                },
                home_manager = {
                    -- nixos with hm module
                    expr =
                    '(builtins.getFlake (builtins.toString "/home/arminveres/nix-conf")).nixosConfigurations."nixos-desktop".options.home-manager.users.type.getSubOptions []',
                    -- hm styl
                    -- expr = '(builtins.getFlake "/home/arminveres/nix-conf").homeConfigurations.arminveres@' .. vim.uv.os_gethostname() .. ".options",
                },
                -- currently not used
                -- flake_parts = { expr = 'let flake = builtins.getFlake ("/home/arminveres/nix-conf"); in flake.debug.options // flake.currentSystem.options', },
            },
        },
    },
}
