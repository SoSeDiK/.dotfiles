{ config, pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    distrobox
  ];

  virtualisation.docker.enable = true;

  users.users.${username}.extraGroups = [ "docker" ];
}
