{ inputs, config, osConfig, lib, self, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  username = "sosedik";
in
{
  imports = [
    inputs.nur.nixosModules.nur

    # Terminal
    "${self}/home/terminal/programs/kitty.nix"

    # Secrets!
    "${self}/secrets/sops-home.nix"

    # Universal defaults
    "${self}/user"

    # WM
    "${self}/user/hyprland"

    # Misc profile-specific thingies
    ("${self}/user/profile/lappytoppy.nix")

    # Apps needing extra settings
    "${self}/user/apps/firefox"
    "${self}/user/apps/codium"
    "${self}/user/apps/github-desktop.nix"
    "${self}/user/apps/spotify.nix"

    "${self}/user/apps/virtualization"
  ];

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
