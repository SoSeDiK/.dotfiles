{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  # Has to be enabled to use flatpak
  xdg.portal.enable = true;

  programs.steam = {
    enable = true;
  };
}
