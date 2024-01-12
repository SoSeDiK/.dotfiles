{ config, pkgs, username, ... }:

{
  imports = [
    ./distrobox.nix
    ./virt-manager.nix
  ];
}
