{ config, pkgs, profileName, ... }:

let inherit (import ../../../profiles/${profileName}/options.nix) username; in
{
  home.packages = with pkgs; [
    wlr-randr # dependency
    nwg-displays
  ];

  xdg.configFile."/home/${username}/.config/hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/hyprland/hypr/monitors.conf";
}
