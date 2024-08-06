{ inputs, pkgs, profileName, ... }:

let
  inherit (import ../profiles/${profileName}/options.nix) username;
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
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
          --sessions ${hyprland-session} \
          --time \
          --remember \
          --remember-session \
          --remember-user-session \
          --greeting "Access restricted. High-profile personnel only. Authorization required."
        '';
        user = "${username}";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
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
