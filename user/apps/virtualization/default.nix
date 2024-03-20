{ config, pkgs, ... }:

{
  # Various packages related to virtualization, compatibility and sandboxing
  imports = [
    ./bottles.nix
    ./virt-manager.nix
  ];
}
