{ config, pkgs, ... }:

let
  cursorName = "Bibata-Modern-Ice"; # Should be synced with home-manager's cursor
in
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  programs.dconf.profiles.gdm.databases = [{
    settings = {
      "org/gnome/desktop/interface" = {
        cursor-theme = cursorName;
        show-battery-percentage = true;
      };
    };
  }];
}
