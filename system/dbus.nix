{ config, pkgs, ... }:

{
  # Sharing options between apps
  services.dbus.enable = true;
}
