{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    glib
    gnome.nautilus
    gedit
    gnome.file-roller
  ];

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nautilus.desktop" ]; # TODO doesn't work? https://github.com/NixOS/nixpkgs/issues/259239
    };
  };

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

  # TODO is this even needed?
  environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
  '';

  services.xserver = {
    libinput.enable = true;
    excludePackages = [ pkgs.xterm ];
  };
}
