{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprshot
  ];

  xdg.userDirs.extraConfig = {
    HYPRSHOT_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  home.sessionVariables = rec {
    HYPRSHOT_DIR  = "$HOME/Pictures/Screenshots";
  };
}
