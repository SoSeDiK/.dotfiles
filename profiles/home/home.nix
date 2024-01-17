{ config, pkgs, lib, inputs, wm, name, username, email, browser, term, editor, ... }: {

  imports = [
    (./. + "../../../user/wm/${wm}/${wm}.nix")
    (./. + "../../../user/apps/browser/${browser}.nix")
    (./. + "../../../user/apps/browser/edge.nix") # Secondary browser :)
    (./. + "../../../user/apps/terminal/${term}.nix")

    ../../user/shell/cli-collection.nix
    ../../user/shell/shell-aliases.nix

    ../../user/apps/misc/git.nix
    ../../user/apps/misc/flatpak.nix
    ../../user/apps/misc/wallpapers.nix
    ../../user/apps/misc/user-apps.nix
    ../../user/apps/virtualization/virtualization.nix

    ../../user/apps/social/discord.nix
    ../../user/apps/social/telegram.nix
  ];

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
    cinnamon.nemo-with-extensions         # file manager
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

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  home.username = username;
  home.homeDirectory = "/home/" + username;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05"; # tldr: Do not change :)
}
