{ config, lib, pkgs, ... }:

let
  cfg = config.programs.piper;
in
{
  options.programs.piper = {
    enable = lib.mkEnableOption "GUI mouse configuration for non-razer mice";

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
    services.ratbagd.enable = true;

    environment.systemPackages = [
      pkgs.piper
    ];

    users.users = lib.genAttrs cfg.users (username: {
      extraGroups = [ "games" ];
    });
  };
}
