{
  inputs',
  lib,
  hmUsers,
  dotAssetsDir,
  ...
}:

{
  services.hypridle = {
    enable = true;
    package = inputs'.hypridle.packages.hypridle;
  };

  # Note: hyprlock depends on hypridle
  programs.hyprlock = {
    enable = true;
    package = inputs'.hyprlock.packages.hyprlock;
  };

  hjem.users = lib.genAttrs hmUsers (username: {
    files = {
      ".config/hypr/hypridle.conf".source = "${dotAssetsDir}/hypr/hyprlock.conf";
      ".config/hypr/hyprlock.conf".source = "${dotAssetsDir}/hypr/hyprlock.conf";
      ".config/hypr/hyprlock_background.png".source = "${dotAssetsDir}/login_wallpaper.png";
    };
  });
}
