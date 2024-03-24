{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard # dependency
    xclip # WINE compat | https://github.com/hyprwm/Hyprland/issues/2319
    cliphist
  ];
}
