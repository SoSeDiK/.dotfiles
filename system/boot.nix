{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Speedup rebuilds by having /tmp be a tmpfs (and reducing strain on hdd/ssd)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  # https://wiki.archlinux.org/title/gaming#Increase_vm.max_map_count
  boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };

  # Boot animation
  boot.plymouth.enable = true;
  # Hide boot logs (untill plymouth can take over stage 1)
  #  boot = {
  #    consoleLogLevel = 0;
  #    initrd.verbose = false;
  #    kernelParams = [
  #      "quiet"
  #      "splash"
  #    ];
  #  };

  # boot.kernelPackages = pkgs.linuxPackages_latest; # NOTE: if switching, also needs change in lenovo.nix
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
