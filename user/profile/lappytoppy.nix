{ config, pkgs, ... }:

let
  # Compile Wallpaper Engine with Wayland
  linux-wallpaperengine = (pkgs.linux-wallpaperengine).overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "Almamu";
      repo = "linux-wallpaperengine";
      # Upstream lacks versioned releases
      rev = "e28780562bdf8bcb2867cca7f79b2ed398130eb9";
      hash = "sha256-VvrYOh/cvWxDx9dghZV5dcOrfMxjVCzIGhVPm9d7P2g=";
    };
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      pkgs.wayland-scanner
    ];
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.wayland
      pkgs.wayland-protocols
    ];
  });
in
{
  # Apps
  home.packages = with pkgs; [
    cinnamon.nemo-with-extensions # file manager
    libsForQt5.ark
    libsForQt5.dolphin
    xfce.thunar
    xfce.thunar-archive-plugin
    direnv
    gimp #gimp-with-plugins
    obs-studio
    libreoffice-qt
    # Utils
    qalculate-qt
    mission-center # Windows-like process manager
    vlc
    loupe # image viewer
    # Dev
    jetbrains.idea-community
    filezilla
    # Gaming
    cartridges # Game launcher
    prismlauncher # Minecraft launcher
    r2modman # Lethal Company mod manager
    # Social
    vesktop # Discord client
    telegram-desktop
    whatsapp-for-linux
    # Chromium brower of choice
    microsoft-edge
    # Misc
    linux-wallpaperengine # requires insecure freeimage-unstable-2021-11-01
    # Fun
    cmatrix # Matrix in terminal
    cava # Audio visualizer in terminal
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01" # linux-wallpaperengine
  ];
}
