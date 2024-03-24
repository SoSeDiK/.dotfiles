{ config, pkgs, ... }:

{
  # Collection of useful (or fun) CLI apps
  environment.systemPackages = with pkgs; [
    zenith-nvidia
    btop
    pciutils
    lsof
    psmisc # used by vfio to have command: fuser
    toybox
    jq # json parser
    wget
    curl
    git
    zip
    unzip
  ];
}
