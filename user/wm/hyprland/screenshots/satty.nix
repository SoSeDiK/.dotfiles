{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    grim slurp # dependencies
    satty
  ];
}
