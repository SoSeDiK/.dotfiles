{ config, pkgs, ... }:

{
  # Collection of useful (or fun) CLI apps
  home.packages = with pkgs; [
    fastfetch # fast neofetch
    killall
    ffmpeg
    diff-so-fancy
  ];
}
