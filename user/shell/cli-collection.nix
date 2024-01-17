{ config, pkgs, ... }:

{
  # Collection of useful (or fun) CLI apps
  home.packages = with pkgs; [
    fastfetch # fast neofetch
    killall
    ffmpeg
    diff-so-fancy
    nurl  # fetch sha256 for packages
    jq    # used by workspace_aware_switch
  ];
}
