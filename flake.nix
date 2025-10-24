{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    zmk-nix = {
      url = "github:lilyinstarlight/zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      zmk-nix,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs (nixpkgs.lib.attrNames zmk-nix.packages);
    in
    {
      packages = forAllSystems (system: rec {
        default = firmware;

        firmware = zmk-nix.legacyPackages.${system}.buildSplitKeyboard {
          name = "firmware";
          extraWestBuildFlags = [
            "-S"
            "zmk-usb-logging"
          ];
          enableZmkStudio = true;

          src = nixpkgs.lib.sourceFilesBySuffices self [
            ".board"
            ".cmake"
            ".conf"
            ".defconfig"
            ".dts"
            ".dtsi"
            ".json"
            ".keymap"
            ".overlay"
            ".shield"
            ".yml"
            "_defconfig"
          ];

          board = "seeeduino_xiao_ble";
          shield = "harite_v3_%PART%";

          zephyrDepsHash = "sha256-6N3IBfumosTNLr38KCb2s2GVtzC+fBPiEznnmfQaJng=";

          meta = {
            description = "ZMK firmware";
            license = nixpkgs.lib.licenses.mit;
            platforms = nixpkgs.lib.platforms.all;
          };
        };

        flash = zmk-nix.packages.${system}.flash.override { inherit firmware; };
        update = zmk-nix.packages.${system}.update;
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          
          # Define shell scripts from aliases
          shellAliases = [
            (pkgs.writeShellScriptBin "bld" ''
              ./scripts/build.sh "$@"
            '')
            (pkgs.writeShellScriptBin "clean" ''
              rm -rf build_left build_right
              echo "Build directories cleaned 🧹"
            '')
            (pkgs.writeShellScriptBin "km" ''
              ./scripts/visual-keymap.sh "$@"
            '')
          ];
        in
        {
          default = (pkgs.callPackage "${zmk-nix}/nix/shell.nix" {
            extraPackages = [ pkgs.python3Packages.setuptools pkgs.gum pkgs.keymap-drawer] ++ shellAliases;
          }).overrideAttrs (oldAttrs: {
            shellHook = (oldAttrs.shellHook or "") + ''
              # echo "ZMK development environment loaded with custom aliases!"
            '';
          });
        }
      );
    };
}
