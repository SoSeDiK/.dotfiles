{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    #rofi-wayland # temporary built from source until the next release
    (pkgs.callPackage "${toString pkgs.path}/pkgs/applications/misc/rofi/wrapper.nix" {
      rofi-unwrapped = (pkgs.rofi-wayland.unwrapped.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
              owner = "lbonn";
              repo = "rofi";
              rev = "b29518f0347d7ab7f9b6e51b6ef68ca663f54879";
              fetchSubmodules = true;
              sha256 = "sha256-85uG51v4YoXive593C1p24loeJUtaZSrhGtEvCCr9Xg=";
        };
      }));
    })
  ];
}
