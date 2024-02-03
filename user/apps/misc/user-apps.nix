{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    github-desktop
    qalculate-qt
    prismlauncher
    gnome.file-roller
    direnv
    jetbrains.idea-community
    mission-center # Windows-like process manager
    loupe # image viewer
    gimp-with-plugins
    vlc
    obs-studio
    libratbag
    piper
    libreoffice-qt
  ];
}
