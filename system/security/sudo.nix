{ lib, pkgs, ... }:

# sudo with insults
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
