{ ... }:

{
  # Power/battery status and related D-Bus events
  services.upower = {
    enable = true;
    percentageCritical = 7;
    percentageLow = 20;
  };

  # Managing power profiles, powerprofilesctl
  services.power-profiles-daemon.enable = true;
}
