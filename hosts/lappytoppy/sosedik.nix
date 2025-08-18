{
  config,
  osConfig,
  lib,
  self,
  pkgs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  username = "sosedik";
  gitUsername = "SoSeDiK";
  gitEmail = "mrsosedik@gmail.com";

  hyprfreeze = pkgs.callPackage "${self}/pkgs/hyprfreeze" { };
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
    "${self}/home/programs/clipboard.nix"
    "${self}/home/programs/github-desktop.nix"
    "${self}/home/programs/quickshell.nix" # Task bar and many other things
    "${self}/home/programs/spicetify.nix"

    # Theming
    "${self}/home/theming/gtk-qt.nix"
    "${self}/home/theming/stylix.nix"

    # Secrets!
    "${self}/secrets/sops-home.nix"

    # Gaming
    "${self}/modules/home-manager/gaming/mangohud.nix"

    # Misc
    "${self}/modules/home-manager/misc/xembed-sni-proxy.nix"

    # Shell
    "${self}/modules/home-manager/shell/shell-aliases.nix"
  ];

  # User apps
  home.packages = with pkgs; [
    nix-inspect
    hyprsunset
    hyprfreeze
    rofi-wayland # App/things launcher
    (bottles.override { removeWarningPopup = true; }) # WINE helper
    helvum # Audio
    scrcpy # View/Control phone screen (also broadcasts audio!)
    kdePackages.kdeconnect-kde
    nurl # fetch sha256 for packages
    libsForQt5.ark # archiver
    direnv
    gimp
    libreoffice-qt
    # Utils
    gnome-clocks
    qalculate-qt
    mission-center # Windows-like process manager
    resources # Process manager
    fsearch # fast search
    cpu-x # PC Info
    fontforge-gtk
    # Media
    loupe # image viewer
    obs-studio # video recorder
    stremio # video streaming
    qbittorrent # torrents
    # Gaming
    prismlauncher # Minecraft launcher
    mcpelauncher-ui-qt # Minecraft Bedrock launcher
    blockbench
    r2modman # Lethal Company mod manager
    space-cadet-pinball # Good Old Pinball
    # Social
    equibop # Discord client
    # inputs'.nix-gaming.packages.wine-discord-ipc-bridge # ToDo broken
    telegram-desktop
    whatsapp-for-linux
    teams-for-linux
    # Extra browsers
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
    lolcat # Because rainbow is cool
    sl # Steam Locomotive
    caffeine-ng # Idle inhibit
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
      init.defaultBranch = "main";
      http.postBuffer = 1048576000;

      # Setup signing commits
      commit.gpgsign = true;
      user.signingkey = "A2263A612AD152CB";
    };
  };
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
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

  home.username = username;
  home.homeDirectory = "/home/${username}";

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11"; # tldr: Do not change :)
}
