{ lib, pkgs, hmUsers, dotAssetsDir, ... }:

{
  environment.systemPackages = with pkgs; [
    nwg-displays
  ];

  hjem.users = lib.genAttrs hmUsers (username: {
    files = {
      ".config/hypr/monitors.conf".source = "${dotAssetsDir}/hypr/monitors.conf";
    };
  });
}
