{ config, pkgs, username, ... }:

{
  home.packages = with pkgs; [
    wlr-randr # dependency
    nwg-displays
  ];

  xdg.configFile."/home/${username}/.config/hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/wm/hyprland/hypr/monitors.conf";
}
