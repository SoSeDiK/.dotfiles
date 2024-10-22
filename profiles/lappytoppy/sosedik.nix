{ inputs, config, osConfig, lib, self, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

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
    "${self}/home/programs/github-desktop.nix"
    "${self}/home/programs/spicetify.nix"

    # Theming
    "${self}/home/theming/stylix.nix"

    # Secrets!
    "${self}/secrets/sops-home.nix"

    # Universal defaults
    "${self}/user"

    # WM
    "${self}/user/hyprland"

    # Misc profile-specific thingies
    ("${self}/user/profile/lappytoppy.nix")
  ];

  # User apps
  home.packages = with pkgs; [
    bottles
    helvum # Audio
    scrcpy # View/Control phone screen (also broadcasts audio!)
    nurl # fetch sha256 for packages
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
