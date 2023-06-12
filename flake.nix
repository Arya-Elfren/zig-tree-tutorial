{
  description = "zig-tree-tutorial";

  outputs = { self, nixpkgs, zig, flake-utils, ... }:
    with flake-utils.lib;
    eachSystem allSystems (system:
    let
      pkgs = import zig.inputs.nixpkgs {
        overlays = [ zig.overlays.default ];
        inherit system;
      };
    in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkgs.zigpkgs.master
          ];
        };
      });
}

