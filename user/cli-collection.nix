{ config, pkgs, ... }:

{
  # Collection of useful (or fun) CLI apps
  home.packages = with pkgs; [
    neofetch
    killall
    ffmpeg
    nurl # fetch sha256 for packages
    jq # used by workspace_aware_switch
  ];
}
