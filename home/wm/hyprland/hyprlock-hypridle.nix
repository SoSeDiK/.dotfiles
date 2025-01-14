{ inputs', config, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  services.hypridle = {
    enable = true;
    package = inputs'.hypridle.packages.hypridle;
  };
  xdg.configFile."hypr/hypridle.conf".source = mkOutOfStoreSymlink "${dotAssetsDir}/hypr/hypridle.conf";

  # Note: hyprlock depends on hypridle
  programs.hyprlock = {
    enable = true;
    package = inputs'.hyprlock.packages.hyprlock;
  };
  xdg.configFile."hypr/hyprlock.conf".source = mkOutOfStoreSymlink "${dotAssetsDir}/hypr/hyprlock.conf";
  xdg.configFile."hypr/hyprlock_background.png".source = mkOutOfStoreSymlink "${dotAssetsDir}/login_wallpaper.png";
}
