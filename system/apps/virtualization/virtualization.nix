{ config, pkgs, ... }:

{
  imports = [
    ./distrobox.nix
    ./virt-manager.nix
  ];
}
