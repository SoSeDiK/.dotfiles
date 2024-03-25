{ config, pkgs, ... }:

let
  cursorName = "Bibata-Modern-Ice"; # Should be synced with home-manager's cursor
  cursorPackage = pkgs.bibata-cursors;
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
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };
    };
  }];
  users.users.gdm.packages = with pkgs; [
    cursorPackage
  ];
}
