{ config, pkgs, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.lenovo-legion-15arh05h
  ];

  environment.systemPackages = with pkgs; [
    lenovo-legion
    linuxKernel.packages.linux_xanmod_latest.lenovo-legion-module
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
}
