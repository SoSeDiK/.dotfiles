{ config, pkgs, ... }:

{
  services.gnome.gnome-keyring = {
    enable = true;
  };

  security.pam.services.gdm.enableGnomeKeyring = true;
  environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
}
