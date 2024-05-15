{ inputs, profileName, ... }:

let
  inherit (import ./options.nix)
    username
    homeDir theme;
in
{
  imports = [
    inputs.nur.nixosModules.nur
    inputs.nix-colors.homeManagerModules.default

    # Secrets!
    ./sops-home.nix

    # Universal defaults
    ../../user

    # WM
    ../../user/hyprland

    # Misc profile-specific thingies
    (./. + "../../../user/profile/${profileName}.nix")

    # Apps needing extra settings
    ../../user/apps/firefox
    ../../user/apps/codium
    ../../user/apps/github-desktop.nix
    ../../user/apps/spotify.nix

    ../../user/apps/virtualization
  ];

  home.username = username;
  home.homeDirectory = homeDir;

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  # Create XDG Dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Enable mime apps
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05"; # tldr: Do not change :)
}
