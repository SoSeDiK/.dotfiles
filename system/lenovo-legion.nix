{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lenovo-legion
    linuxKernel.packages.linux_xanmod_latest.lenovo-legion-module
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
}
