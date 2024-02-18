{ config, pkgs, ... }:

{
  imports = [
    ./dbus.nix # sharing options between apps
    ./keyring.nix # keeping passwords / sessions
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [ wayland ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
