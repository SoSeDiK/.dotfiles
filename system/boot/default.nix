{ pkgs, ... }:

{
  # Speedup rebuilds by having /tmp be a tmpfs (and reducing strain on hdd/ssd)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  # https://wiki.archlinux.org/title/gaming#Increase_vm.max_map_count
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  # https://xanmod.org/
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
