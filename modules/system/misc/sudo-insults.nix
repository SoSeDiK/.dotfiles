{ lib, pkgs, ... }:

# sudo with insults
{
  security.sudo = {
    enable = true;
    # Default sudo packet, but with printing insults on incorrect password
    package = pkgs.sudo.override { withInsults = true; };

    # Enable sudo only for wheel users
    execWheelOnly = lib.mkForce true;

    # Require password for wheel users
    wheelNeedsPassword = lib.mkDefault true;
  };
}
