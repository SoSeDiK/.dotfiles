{ pkgs, self, ... }:

let
  appleFonts = pkgs.callPackage "${self}/pkgs/fonts/apple-fonts.nix" { };
in
{
  fonts.packages = [
    appleFonts # Mostly for use by Firefox theme
  ];
}
