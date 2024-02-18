{ inputs, config, lib, pkgs, gtkThemeFromScheme, wm, browser, term, editor, ... }:

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

    (./. + "../../../user/wm/${wm}/${wm}.nix")
    (./. + "../../../user/apps/browser/${browser}.nix")
    (./. + "../../../user/apps/browser/edge.nix") # Secondary browser :)

    ../../user/shell/cli-collection.nix
    ../../user/shell/shell-aliases.nix

    ../../user/apps/misc/flatpak.nix
    ../../user/apps/misc/wallpapers.nix
    ../../user/apps/misc/user-apps.nix
    ../../user/apps/virtualization/virtualization.nix

    ../../user/apps/social/discord.nix
    ../../user/apps/social/telegram.nix
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

  # Set default cursor
  # Also needs «dconf write /org/gnome/desktop/interface/cursor-theme "'Bibata-Modern-Ice'"» executed for some apps
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

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
    TERM = term;
    BROWSER = browser;

    # Since I'm on NVIDIA...
    WLR_NO_HARDWARE_CURSORS = 1;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs.home-manager.enable = true;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05"; # tldr: Do not change :)
}
