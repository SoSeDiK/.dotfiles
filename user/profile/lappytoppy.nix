{ config, pkgs, ... }:

{
  # Apps
  home.packages = with pkgs; [
    cinnamon.nemo-with-extensions # file manager
    libsForQt5.ark
    libsForQt5.dolphin
    xfce.thunar
    xfce.thunar-archive-plugin
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
