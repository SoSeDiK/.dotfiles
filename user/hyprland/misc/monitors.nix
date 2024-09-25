{ config, pkgs, self, ... }:

{
  home.packages = with pkgs; [
    wlr-randr # dependency
    nwg-displays
  ];

  xdg.configFile."hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "${self}/user/hyprland/hypr/monitors.conf";
}
