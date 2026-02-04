{
  description = "NeoVIM configuration based on nightly overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      neovim-nightly,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ neovim-nightly.overlays.default ];
        };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "neovim-config";
          src = self;

          installPhase = ''
            mkdir -p $out/share/nvim/site/nvim
            cp -r * $out/share/nvim/site/nvim
          '';

          nativeBuildInputs = [ pkgs.makeWrapper ];
          postFixup = ''
            makeWrapper ${pkgs.neovim}/bin/nvim $out/bin/nvim \
              --set VIMRUNTIME ${pkgs.neovim}/share/nvim/runtime \
              --set XDG_CONFIG_HOME "$out/share/nvim/site"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.neovim}/bin/nvim";
        };
      }
    );
}
