{ config, pkgs, ... }:

{
  # Apps
  home.packages = with pkgs; [
    gnome.file-roller
    direnv
    gimp-with-plugins
    obs-studio
    libreoffice-qt
    # Utils
    qalculate-qt
    mission-center # Windows-like process manager
    vlc
    loupe # image viewer
    # Dev
    jetbrains.idea-community
    # Gaming
    prismlauncher
    # Social
    telegram-desktop
    whatsapp-for-linux
    # Chromium brower of choice
    microsoft-edge
    # Misc
    linux-wallpaperengine
  ];
}
