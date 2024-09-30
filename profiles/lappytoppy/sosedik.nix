{ inputs, config, osConfig, lib, self, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  username = "sosedik";
in
{
  imports = [
    inputs.nur.nixosModules.nur

    # Terminal
    "${self}/home/terminal/programs/kitty.nix"

    # Programs
    "${self}/home/programs/codium"
    "${self}/home/programs/firefox"
    "${self}/home/programs/github-desktop.nix"
    "${self}/home/programs/spicetify.nix"

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
  ];

  # Equalizer
  services.easyeffects.enable = true;

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
