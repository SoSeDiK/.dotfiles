{ config, pkgs, profileName, ... }:

let
  inherit (import ../../profiles/${profileName}/options.nix) flakeDir;
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
  imageViewer = "org.gnome.Loupe.desktop";
in
{
  # Apps
  home.packages = with pkgs; [
    (callPackage ../apps/sigma.nix { }) # file manager
    (callPackage ../apps/sigma-v2.nix { }) # file manager
    cinnamon.nemo-with-extensions # file manager
    libsForQt5.ark # archiver
    direnv
    (gimp-with-plugins.override { plugins = with gimpPlugins; [ ]; })
    libreoffice-qt
    # Utils
    qalculate-qt
    mission-center # Windows-like process manager
    fsearch # fast search
    # Media
    vlc # video player
    loupe # image viewer
    obs-studio
    # Dev
    jetbrains-toolbox
    filezilla
    # Gaming
    cartridges # Game launcher
    prismlauncher # Minecraft launcher
    r2modman # Lethal Company mod manager
    plasma-workspace # Provides package for xembed-sni-proxy; required for WINE apps to display tray icon properly (e.g. Blish HUD)
    # Social
    vesktop # Discord client
    telegram-desktop
    whatsapp-for-linux
    # Extra browsers
    microsoft-edge
    tor-browser
    # Misc
    linux-wallpaperengine # TODO requires insecure freeimage-unstable-2021-11-01
    # Fun
    cmatrix # Matrix in terminal
    cava # Audio visualizer in terminal
  ];

  # Allows Blish HUD to run
  services.xembed-sni-proxy.enable = true;

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nemo.desktop";
    "image/png" = imageViewer;
    "image/apng" = imageViewer;
    "image/jpeg" = imageViewer; # + .jpg
    "image/pjpeg" = imageViewer; # + .jpg
    "image/jxl" = imageViewer;
    "image/gif" = imageViewer;
    "image/webp" = imageViewer;
    "image/svg+xml" = imageViewer; # .svg
    "image/x-icon" = imageViewer; # .ico
    "image/avif" = imageViewer;
    "image/bmp" = imageViewer;
    "image/tiff" = imageViewer; # + .tif
    "image/x-tiff" = imageViewer; # + .tif
  };
  xdg.mimeApps.associations.added = {
    "application/x-portable-anymap" = imageViewer; # .pnm
    "image/x-portable-anymap" = imageViewer; # .pnm
  };

  # Custom handlr rules
  xdg.configFile."handlr/handlr.toml".text = ''
    enable_selector = false
    selector = "rofi -dmenu -i -p 'Open With: '"
    term_exec_args = '-e'

    # GW 2 thingies
    [[handlers]]
    exec = '${flakeDir}/user/files/scripts/firefox-open.sh gaming "%u"'
    regexes = [
      '(https://)?.*guildwars2\.com.*',
      '(https://)?gw2efficiency\.com.*',
      '(https://)?gw2crafts\.net.*',
      '(https://)?blishhud\.com.*'
    ]

    # Any other http & https URL since handlr is a default handler for them
    [[handlers]]
    exec = '${flakeDir}/user/files/scripts/firefox-open.sh default "%u"'
    regexes = ['^(http|https)://.*\..+$']
  '';

  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01" # linux-wallpaperengine
  ];
}
