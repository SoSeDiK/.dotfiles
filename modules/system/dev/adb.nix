{ config, lib, ... }:

let
  cfg = config.programs.adb;
in
{
  options.programs.adb = {
    users = lib.mkOption {
      default = [ ];
      example = ''
        [ "username1" "username2" ]
      '';
      type = with lib.types; listOf str;
      description = ''
        Users that can use adb.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.genAttrs cfg.users (username: {
      extraGroups = [ "adbusers" ];
    });
  };
}
