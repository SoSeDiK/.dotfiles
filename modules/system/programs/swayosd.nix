{
  config,
  lib,
  pkgs,
  homeUsers,
  flakeDir,
  hostName,
  ...
}:

let
  pkg = pkgs.swayosd;
  stylePath = null;
  topMargin = null;
in {
  # Indicators for volume, brightness, etc.
  environment.systemPackages = [
    pkg
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/swayosd/config.toml".source = "${flakeDir}/hosts/${hostName}/assets/swayosd/config.toml";
    };
  });

  systemd.user = {
    services.swayosd = {
      unitConfig = {
        Description = "Volume/backlight OSD indicator";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Documentation = "man:swayosd(1)";
        StartLimitBurst = 5;
        StartLimitIntervalSec = 10;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkg}/bin/swayosd-server"
          + (lib.optionalString (stylePath != null) " --style ${lib.escapeShellArg stylePath}")
          + (lib.optionalString (topMargin != null) " --top-margin ${toString topMargin}");
        Restart = "always";
        RestartSec = "2s";
      };

      wantedBy = [ "graphical-session.target" ];
    };
  };
}
