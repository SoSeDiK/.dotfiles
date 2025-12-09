{
  lib,
  pkgs,
  homeUsers,
  flakeDir,
  hostName,
  ...
}:

{
  # GUI monitors management for Hyprland
  environment.systemPackages = with pkgs; [
    nwg-displays
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/hypr/monitors.conf".source = "${flakeDir}/hosts/${hostName}/assets/hypr/monitors.conf";
    };
  });
}
