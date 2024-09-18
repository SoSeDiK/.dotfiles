###
# Enables sudo with insults,
# and only allows wheel users to use it
###
{ lib, pkgs, ... }:

let
  inherit (lib) mkForce mkDefault;
in
{
  security.sudo = {
    enable = true;
    # Default sudo packet, but with printing insults on incorrect password
    package = pkgs.sudo.override { withInsults = true; };

    # Enable sudo only for wheel users
    execWheelOnly = mkForce true;

    # Require password for wheel users
    wheelNeedsPassword = mkDefault true;
  };
}
