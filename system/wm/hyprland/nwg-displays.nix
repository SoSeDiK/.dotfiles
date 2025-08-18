{
  lib,
  pkgs,
  homeUsers,
  flakeDir,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    nwg-displays
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/hypr/monitors.conf".source = "${flakeDir}/assets/hypr/monitors.conf";
    };
  });
}
