{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://wiki.archlinux.org/title/gaming#Increase_vm.max_map_count
  boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };

  # Boot animation
  boot.plymouth.enable = true;
  # Hide boot logs (untill playmouth can take over stage 1)
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest; # NOTE: if switching, also needs change in lenovo.nix
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
