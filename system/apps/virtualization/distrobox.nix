{ pkgs, config, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) username;
in
{
  environment.systemPackages = with pkgs; [
    distrobox
  ];

  virtualisation.docker.enable = true;
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   defaultNetwork.settings.dns_enabled = true;
  # };


  users.users.${username}.extraGroups = [ "docker" ];
}
