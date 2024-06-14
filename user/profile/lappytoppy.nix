{ inputs, pkgs, profileName, ... }:

let
  inherit (import ../../profiles/${profileName}/options.nix) flakeDir;
  # Compile Wallpaper Engine with Wayland support
  # linux-wallpaperengine = (pkgs.linux-wallpaperengine).overrideAttrs (oldAttrs: {
  #   src = pkgs.fetchFromGitHub {
  #     owner = "Almamu";
  #     repo = "linux-wallpaperengine";
  #     rev = "4bc52050341b8bceb01f2b2f1ccfd6500b7f3b78";
  #     hash = "sha256-t89L1aZtmZJosjKVFuwmKFfz8cImN7kl5QAdvKDgjeY=";
  #   };
  #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
  #     pkgs.wayland-scanner
  #   ];
  #   buildInputs = oldAttrs.buildInputs ++ [
  #     pkgs.wayland
  #     pkgs.wayland-protocols
  #   ];
  # });
  # Only pull xembed-sni-proxy from plasma-workspace
  # Required for WINE apps to display tray icon properly (e.g. Blish HUD)
  xembed-sni-proxy = pkgs.runCommandNoCC "xembed-sni-proxy" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.plasma-workspace}/bin/xembedsniproxy $out/bin
  '';
  imageViewer = "org.gnome.Loupe.desktop";
in
{
  # Apps
  home.packages = with pkgs; [
    libsForQt5.ark # archiver
    direnv
    gimp
    libreoffice-qt
    # Utils
    qalculate-qt
    mission-center # Windows-like process manager
    fsearch # fast search
    # Media
    vlc # video player
    loupe # image viewer
    obs-studio # video recorder
    stremio # video streaming
    qbittorrent-qt5 # torrents
    # Dev
    jetbrains.idea-community
    android-studio
    filezilla
    postman
    # Gaming
    cartridges # Game launcher
    prismlauncher # Minecraft launcher
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin # osu!
    r2modman # Lethal Company mod manager
    # Social
    vesktop # Discord client
    inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
    telegram-desktop
    whatsapp-for-linux
    # Extra browsers
    microsoft-edge
    tor-browser
    # Misc
    #linux-wallpaperengine # TODO requires insecure freeimage-unstable-2021-11-01
    smile # emoji picker
    # Fun
    cmatrix # Matrix in terminal
    ollama # AI!
  ];

  # Gaming
  programs.mangohud.enable = true;

  # Allows Blish HUD to run
  services.xembed-sni-proxy.enable = true;
  services.xembed-sni-proxy.package = xembed-sni-proxy;

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nautilus.desktop";
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
  xdg.configFile."handlr/handlr.toml".source =
    (pkgs.formats.toml { }).generate "handlr-config" {
      enable_selector = false;
      selector = "rofi -dmenu -i -p 'Open With: '";
      term_exec_args = "";
      handlers = [
        # GW 2 thingies
        {
          exec = "${flakeDir}/user/files/scripts/firefox-open.sh gaming %u";
          regexes = [
            "(https://)?.*guildwars2\.com.*"
            "(https://)?gw2efficiency\.com.*"
            "(https://)?gw2crafts\.net.*"
            "(https://)?blishhud\.com.*"
          ];
        }
        # Any other http & https URLs since handlr is a default handler for them
        {
          exec = "${flakeDir}/user/files/scripts/firefox-open.sh default %u";
          regexes = [ "^(http|https)://.*\..+$" ];
        }
      ];
    };

  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01" # linux-wallpaperengine
  ];
}
