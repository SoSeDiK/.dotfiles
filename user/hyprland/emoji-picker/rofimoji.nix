{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofimoji
  ];
}
