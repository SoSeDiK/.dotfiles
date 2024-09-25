{ config, lib, pkgs, ... }:

let
  cfg = config.services.printers;
in
{
  options.services.printers = {
    enable = lib.mkEnableOption "Enable support for printers";

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
    services = {
      printing.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      ipp-usb.enable = true;
    };

    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };

    programs.system-config-printer.enable = true;

    users.users = lib.genAttrs cfg.users (username: {
      extraGroups = [ "scanner" "lp" ];
    });
  };
}
