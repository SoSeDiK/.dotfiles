{ config, pkgs, ... }:

{
  # Collection of useful (or fun) CLI apps
  home.packages = with pkgs; [
    neofetch
    killall
    ffmpeg
    nurl # fetch sha256 for packages
  ];

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
    ];
  };
}
