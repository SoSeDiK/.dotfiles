{ pkgs, ... }:

{
  # Keeping passwords / sessions
  services.gnome.gnome-keyring.enable = true;

  # # Auto start polkit
  # systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #   description = "polkit-gnome-authentication-agent-1";
  #   wantedBy = [ "graphical-session.target" ];
  #   wants = [ "graphical-session.target" ];
  #   after = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };

  # Keyrind data visualizer
  programs.seahorse.enable = true;

  # Storing app settings
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    dconf-editor
  ];
}
