{ config, lib, ... }:

let
  cfg = config.customs.ydotool;
in
{
  options.customs.ydotool = {
    enable = lib.mkEnableOption "Wayland auto clicker workaround";

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
    programs.ydotool.enable = true;

    users.users = lib.genAttrs cfg.users (username: {
      extraGroups = [ "${config.programs.ydotool.group}" ];
    });
  };
}
