{ config, pkgs, profileName, ... }:

let inherit (import ../../../profiles/${profileName}/options.nix) username homeDir flakeDir; in
{
  home.packages = with pkgs; [
    wlr-randr # dependency
    nwg-displays
  ];

  xdg.configFile."${homeDir}/.config/hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/hyprland/hypr/monitors.conf";
}
