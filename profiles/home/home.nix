{ config, pkgs, inputs, wm, name, username, email, browser, term, editor, ... }: {

  imports = [
    (./. + "../../../user/wm/${wm}/${wm}.nix")
    (./. + "../../../user/apps/browser/${browser}.nix")
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

  home.packages = with pkgs; [
    cinnamon.nemo-with-extensions         # file manager
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
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

  xdg.userDirs = {
    pictures = "${config.home.homeDirectory}/Pictures";
  };

  home.stateVersion = "23.05"; # Do not change :)

}
