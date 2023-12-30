{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard # dependency
    cliphist
  ];
}
