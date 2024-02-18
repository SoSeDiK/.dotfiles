{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./display-manager.nix
    ./flatpak.nix
    ./gnome-disks.nix
    ./nh.nix
    ./ntp.nix # Time sync
    ./openrazer.nix
    ./piper.nix
    ./pipewire.nix # Sound management
    ./polkit.nix
    ./printer.nix
    ./steam.nix
    ./zsh.nix
  ];
}
