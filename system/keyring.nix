{ config, lib, pkgs, ... }:

{
  # Keeping passwords / sessions
  environment.systemPackages = with pkgs; [
    glib
    gedit
  ];

  services.gnome.gnome-keyring = {
    enable = true;
  };

  # Needed for GNOME services outside of GNOME Desktop
  services.dbus.packages = [ pkgs.gcr ];

  # Enable keyring on login
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };
}
