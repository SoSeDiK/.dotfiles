{ pkgs, ... }:

{
  # Collection of useful (or fun) CLI apps
  environment.systemPackages = with pkgs; [
    zenith-nvidia
    nvtopPackages.full
    pciutils
    lsof
    psmisc # used by vfio to have command: fuser
    coreutils-full
    bc # basic calculator
    jq # json parser
    file
    wget
    curl
    git
    zip
    unzip
  ];
}
