{
  pkgs,
  lib,
  inputs,
  homeUsers,
  ...
}:

{
  imports = [
    inputs.nixos-hardware-2.nixosModules.microsoft-surface-book-3
  ];

  environment.systemPackages = with pkgs; [
    surface-control
  ];

  users.users = lib.genAttrs homeUsers (username: {
    extraGroups = [ "surface-control" ];
  });

  hardware.microsoft-surface.kernelVersion = "stable";

  services.iptsd.enable = true;
}
