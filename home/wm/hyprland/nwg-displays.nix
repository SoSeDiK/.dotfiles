{ config, pkgs, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    nwg-displays
  ];

  xdg.configFile."hypr/monitors.conf".source = mkOutOfStoreSymlink "${dotAssetsDir}/hypr/monitors.conf";
}
