{ inputs, inputs', config, osConfig, lib, self, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  linux-wallpaperengine = pkgs.callPackage "${self}/pkgs/linux-wallpaperengine" { }; # TODO not yet in nixpkgs

  username = "sosedik";
  gitUsername = "SoSeDiK";
  gitEmail = "mrsosedik@gmail.com";
in
{
  imports = [
    inputs.nur.nixosModules.nur

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

    # Misc profile-specific thingies
    ("${self}/user/profile/lappytoppy.nix")
  ];

  # User apps
  home.packages = with pkgs; [
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
    android-studio
    filezilla
    postman
    # Gaming
    prismlauncher # Minecraft launcher
    r2modman # Lethal Company mod manager
    # space-cadet-pinball # Good Old Pinball # TODO Depends on archive.org, which is currently down
    # Social
    vesktop # Discord client
    inputs'.nix-gaming.packages.wine-discord-ipc-bridge
    telegram-desktop
    whatsapp-for-linux
    # Extra browsers
    microsoft-edge
    tor-browser
    # Misc
    linux-wallpaperengine
    smile # emoji picker
    # Fun
    cmatrix # Matrix in terminal
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
  programs.mangohud.enable = true;

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

  home.username = username;
  home.homeDirectory = "/home/${username}";

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05"; # tldr: Do not change :)
}
