{ ... }:

{
  programs.mangohud = {
    enable = true;
    # https://github.com/flightlessmango/MangoHud/blob/master/data/MangoHud.conf
    settings = {
      # Disable / hide the hud by default
      no_display = true;
    };
  };
}
