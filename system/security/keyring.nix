{ pkgs, ... }:

{
  # Keeping passwords / sessions
  # services.gnome.gnome-keyring.enable = true;

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

  # Unlock keyring on login
  # security.pam.services.greetd.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    dconf-editor
  ];

  # Needed for GNOME services outside of GNOME Desktop
  services.dbus.packages = [ pkgs.gcr ];

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };
}
