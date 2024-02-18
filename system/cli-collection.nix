{ config, pkgs, ... }:

{
  # Collection of useful (or fun) CLI apps
  environment.systemPackages = with pkgs; [
    zenith-nvidia
    btop
    pciutils
    lsof
    toybox
    wget
    curl
    git
    zip
    unzip
  ];
}
