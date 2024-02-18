{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lenovo-legion
    linuxKernel.packages.linux_xanmod_latest.lenovo-legion-module
  ];

  # Fix invisible cursor on external monitors
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
}
