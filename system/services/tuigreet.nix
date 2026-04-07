{
  config,
  lib,
  inputs',
  ...
}:

let
  tuigreet = inputs'.tuigreet.packages.tuigreet;
in
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session =
        let
          baseSessionsDir = "${config.services.displayManager.sessionData.desktops}";
          xSessions = "${baseSessionsDir}/share/xsessions";
          waylandSessions = "${baseSessionsDir}/share/wayland-sessions";
          tuigreetOptions = [
            "--sessions ${waylandSessions}:${xSessions}"
            "--time"
            "--remember"
            "--remember-session"
            "--greeting 'Access restricted. High-profile personnel only. Authorization required.'"
          ];
        in
        {
          command = "${lib.getExe tuigreet} ${lib.concatStringsSep " " tuigreetOptions}";
        };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
