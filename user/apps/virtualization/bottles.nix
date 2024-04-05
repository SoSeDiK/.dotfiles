{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    bottles
    lutris
    wineWowPackages.waylandFull
    winetricks
  ];
}
