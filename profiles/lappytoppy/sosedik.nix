{ inputs', config, osConfig, lib, self, pkgs, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  username = "sosedik";
  gitUsername = "SoSeDiK";
  gitEmail = "mrsosedik@gmail.com";

  hyprfreeze = pkgs.callPackage "${self}/pkgs/hyprfreeze" { };

  # Only pull xembed-sni-proxy from plasma-workspace # TODO Find a way to not have to depend on plasma-workspace?
  # Converts legacy xembed tray icons to SNI onces, required for WINE apps (e.g. Blish HUD)
  xembed-sni-proxy = pkgs.runCommandNoCC "xembed-sni-proxy" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.plasma-workspace}/bin/xembedsniproxy $out/bin
  '';
  imageViewer = "org.gnome.Loupe.desktop";
  videoPlayer = "mpv.desktop";
in
{
  imports = [
    # Terminal
    "${self}/home/terminal/clis/fastfetch.nix"
    "${self}/home/terminal/programs/cava.nix"
    "${self}/home/terminal/programs/kitty.nix"
    "${self}/home/terminal/shell/shell-aliases.nix"
    "${self}/home/terminal/shell/starship.nix"
    "${self}/home/terminal/shell/zsh.nix"

    # Programs
    "${self}/home/programs/codium"
    "${self}/home/programs/firefox"
    "${self}/home/programs/mpv"
    "${self}/home/programs/ags.nix" # Task bar and many other things
    "${self}/home/programs/cliphist.nix"
    "${self}/home/programs/github-desktop.nix"
    # "${self}/home/programs/quickshell.nix" # Task bar and many other things # TODO broken
    "${self}/home/programs/screenshots.nix"
    "${self}/home/programs/spicetify.nix"

    # Theming
    "${self}/home/theming/gtk-qt.nix"
    "${self}/home/theming/stylix.nix"

    # Secrets!
    "${self}/secrets/sops-home.nix"

    # WM
    "${self}/home/wm/hyprland"
    ## Managing idle & screen lock
    "${self}/home/wm/hyprland/hyprlock-hypridle.nix"
    ## GUI monitors management
    "${self}/home/wm/hyprland/nwg-displays.nix"
  ];

  # User apps
  home.packages = with pkgs; [
    nix-inspect
    hyprsunset
    hyprfreeze
    rofi-wayland # App/things launcher
    bottles # WINE helper
    helvum # Audio
    scrcpy # View/Control phone screen (also broadcasts audio!)
    nurl # fetch sha256 for packages
    libsForQt5.ark # archiver
    direnv
    gimp
    libreoffice-qt
    # Utils
    qalculate-qt
    mission-center # Windows-like process manager
    fsearch # fast search
    cpu-x # PC Info
    fontforge
    # Media
    loupe # image viewer
    obs-studio # video recorder
    stremio # video streaming
    qbittorrent # torrents
    # Dev
    jetbrains.idea-community-bin
    jetbrains.rust-rover
    android-studio
    filezilla
    postman
    # Gaming
    prismlauncher # Minecraft launcher
    r2modman # Lethal Company mod manager
    space-cadet-pinball # Good Old Pinball
    # Social
    equibop # Discord client
    inputs'.nix-gaming.packages.wine-discord-ipc-bridge
    telegram-desktop
    whatsapp-for-linux
    # Extra browsers
    microsoft-edge
    tor-browser
    # Misc
    linux-wallpaperengine
    smile # emoji picker
    pantheon.elementary-iconbrowser # Browsing GTK icons
    playerctl # Control media player
    pamixer # Volume control
    wl-mirror # App/screen mirroring
    # Fun CLIs
    cmatrix # Matrix in terminal
    dotacat # Because rainbow is cool
    sl # Steam Locomotive
  ];

  # Better cd command
  programs.zoxide.enable = true;

  # Equalizer
  services.easyeffects.enable = true;

  # Setup git
  programs.git = {
    enable = true;
    userName = gitUsername;
    userEmail = gitEmail;
    lfs.enable = true;
    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      http.postBuffer = 1048576000;
    };
  };

  # Gaming
  programs.mangohud = {
    enable = true;
    # https://github.com/flightlessmango/MangoHud/blob/master/data/MangoHud.conf
    settings = {
      # Disable / hide the hud by default
      no_display = true;
    };
  };

  # Create symlink for Steam games
  home.file."Games/Steam" = lib.mkIf osConfig.programs.steam.enable {
    source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/Steam/steamapps/common";
  };

  # Create XDG Dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Enable mime apps
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # Allows Blish HUD to show up in tray
  # services.snixembed.enable = true;
  # services.xembed-sni-proxy.enable = true; # TODO failing to start
  # services.xembed-sni-proxy.package = xembed-sni-proxy;

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "org.gnome.Nautilus.desktop";
    # Images
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
    # Videos
    "video/x-matroska" = videoPlayer; # .mkv
    "video/avi" = videoPlayer;
    "video/x-msvideo" = videoPlayer; # .avi
    "video/mp4" = videoPlayer;
    "video/mpeg" = videoPlayer;
    "video/ogg" = videoPlayer;
    "video/webm" = videoPlayer;
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
          exec = "${dotAssetsDir}/scripts/firefox-open.sh gaming %u";
          regexes = [
            "(https://)?.*guildwars2\.com.*"
            "(https://)?gw2efficiency\.com.*"
            "(https://)?gw2crafts\.net.*"
            "(https://)?blishhud\.com.*"
          ];
        }
        # Terraria
        {
          exec = "${dotAssetsDir}/scripts/firefox-open.sh gaming %u";
          regexes = [
            "(https://)?terraria\.wiki\.gg.*"
            "(https://)?calamitymod\.wiki\.gg.*"
          ];
        }
        # Any other http & https URLs since handlr is a default handler for them
        {
          # exec = "${dotAssetsDir}/scripts/test.sh %u";
          exec = "${dotAssetsDir}/scripts/firefox-open.sh default %u";
          regexes = [ "^(http|https):.+$" ];
        }
      ];
    };

  home.username = username;
  home.homeDirectory = "/home/${username}";

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05"; # tldr: Do not change :)
}
