{ pkgs, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) username;
in
{
  environment.systemPackages = with pkgs; [
    distrobox
    boxbuddy
    podman-compose
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
}
