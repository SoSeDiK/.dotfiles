{ pkgs, ... }:

{
  # Keeping passwords / sessions
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    dconf-editor
  ];

  # Needed for GNOME services outside of GNOME Desktop
  services.dbus.packages = [ pkgs.gcr ];

  # Enable keyring on login
  # security.pam.services.greetd.enableGnomeKeyring = true;

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };
}
