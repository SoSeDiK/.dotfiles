{
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = with pkgs; [
    # For debugging and troubleshooting Secure Boot
    sbctl
  ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Lanzaboote replaces the systemd-boot module
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.loader.efi.canTouchEfiVariables = true;
}
