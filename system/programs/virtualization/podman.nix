{ config, lib, pkgs, ... }:

let
  cfg = config.programs.podman;
in
{
  options.programs.podman = {
    enable = lib.mkEnableOption "Podman, BoxBuddy, Distrobox";

    users = lib.mkOption {
      default = [ ];
      example = ''
        [ "username1" "username2" ]
      '';
      type = with lib.types; listOf str;
      description = ''
        Users that can change device options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
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

    users.users = lib.genAttrs cfg.users (username: {
      extraGroups = [ "docker" ];
    });
  };
}
