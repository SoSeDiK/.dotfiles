{ ... }:

{
  boot.kernelModules = [ "ntsync" ];

  services.udev.extraRules = ''
    KERNEL=="ntsync", MODE="0644"
  '';
}
