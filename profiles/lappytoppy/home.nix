{ inputs, config, lib, pkgs, profileName, ... }:

let
  inherit (import ./options.nix)
    name username
    homeDir theme;
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default

    # Universal defaults
    ../../user

    # WM
    ../../user/hyprland

    # Misc profile-specific thingies
    (./. + "../../../user/profile/${profileName}.nix")

    # Apps needing extra settings
    ../../user/apps/discord
    ../../user/apps/firefox
    ../../user/apps/codium.nix
    ../../user/apps/github-desktop.nix

    ../../user/apps/virtualization/virtualization.nix # TODO
  ];

  home.username = username;
  home.homeDirectory = homeDir;

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Let system handle keyboards
  # https://nixos.wiki/wiki/Keyboard_Layout_Customization
  home.keyboard = null;

  programs.home-manager.enable = true;

  # Since using standalone home-manager
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05"; # tldr: Do not change :)
}
