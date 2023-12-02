{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    purescript-overlay.url = "github:thomashoneyman/purescript-overlay";
    purescript-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    purescript-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [purescript-overlay.overlays.default];
      pkgs = import nixpkgs {inherit system overlays;};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # PureScript tools
          purs
          purs-tidy
          purs-backend-es
          spago-unstable
          # Node
          nodejs
          # Nix
          alejandra
        ];
      };

      checks = {
        format =
          pkgs.runCommand "check-format"
          {
            buildInputs = with pkgs; [
              alejandra
              purs-tidy
            ];
          } ''
            ${pkgs.alejandra}/bin/alejandra --check ${./.}
            ${pkgs.purs-tidy}/bin/purs-tidy check ${./src}
            touch $out
          '';
      };
    });
}
