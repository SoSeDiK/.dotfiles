{ pkgs, ... }:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
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
      default_session = {
        command = ''
          ${tuigreet} \
          --time \
          --remember \
          --remember-user-session \
          --greeting "Access restricted. High-profile personnel only. Authorization required."
        '';
      };
    };
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

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
