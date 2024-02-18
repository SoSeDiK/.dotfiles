{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./display-manager.nix
    ./flatpak.nix
    ./ntp.nix # Time sync
    ./pipewire.nix # Sound management
    ./polkit.nix
    ./printer.nix
  ];
}
