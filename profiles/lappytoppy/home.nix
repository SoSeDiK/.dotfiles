{ inputs, config, lib, pkgs, profileName, wm, editor, ... }:

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

    # Misc profile-specific thingies
    (./. + "../../../user/profile/${profileName}.nix")

    # Apps needing extra settings
    ../../user/apps/discord
    ../../user/apps/firefox
    ../../user/apps/github-desktop.nix

    (./. + "../../../user/wm/${wm}/${wm}.nix")

    ../../user/apps/virtualization/virtualization.nix
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

  ###

  home.packages = with pkgs; [
    nixpkgs-fmt # formatter for codium
    cinnamon.nemo-with-extensions # file manager
  ];

  # yeah.... custom heyboards are managed by env :/
  # https://nixos.wiki/wiki/Keyboard_Layout_Customization
  home.keyboard = null;

  # Also has "password-store": "gnome" added to ~/.vscode/argv.json
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      arrterian.nix-env-selector
    ];
    # userSettings = {
    #     "window.titleBarStyle" = "custom";  # https://github.com/microsoft/vscode/issues/181533
    #     # User settings
    #     "editor.wordWrap" = "on";
    # };
  };

  home.sessionVariables = {
    EDITOR = editor;

    # Since I'm on NVIDIA...
    WLR_NO_HARDWARE_CURSORS = 1;
  };

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
