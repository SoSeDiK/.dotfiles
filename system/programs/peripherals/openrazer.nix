{ config, lib, pkgs, ... }:

let
  cfg = config.programs.openrazer;
in
{
  options.programs.openrazer = {
    enable = lib.mkEnableOption "Open Razer daemon and Polychromatic frontend";

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

    betteryNotifier = lib.mkOption {
      default = false;
      example = ''
        true
      '';
      type = lib.types.bool;
      description = ''
        Whether to enable the battery notifier.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openrazer-daemon
      # Front-end control
      polychromatic
    ];

    hardware.openrazer = {
      enable = true;
      users = cfg.users;
      batteryNotifier.enable = cfg.betteryNotifier;
    };
  };
}
