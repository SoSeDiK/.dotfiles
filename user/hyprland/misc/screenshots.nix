{ inputs, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.shadower.packages.${pkgs.system}.shadower
    satty
  ];
}
