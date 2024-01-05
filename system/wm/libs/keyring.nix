{ config, pkgs, lib, ... }:

{
  services.gnome.gnome-keyring = {
    enable = true;
  };

  environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
  '';
}
