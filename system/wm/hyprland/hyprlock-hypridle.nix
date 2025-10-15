{
  inputs',
  lib,
  homeUsers,
  flakeDir,
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

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/hypr/hypridle.conf".source = "${flakeDir}/assets/hypr/hypridle.conf";
      ".config/hypr/hyprlock.conf".source = "${flakeDir}/assets/hypr/hyprlock.conf";
      ".config/hypr/hyprlock_background.png".source = "${flakeDir}/assets/login_wallpaper.png";
    };
  });
}
