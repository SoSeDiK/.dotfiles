let
  # (!) Make sure to change on new setup!
  name = "SoSeDiK";
  username = "sosedik";
  hostname = "lappytoppy";
  homeDir = "/home/${username}";
in
{
  # User Variables
  name = "${name}";
  username = "${username}";
  hostname = "${hostname}";

  homeDir = "${homeDir}";
  flakeDir = "${homeDir}/.dotfiles";

  # Git
  gitUsername = "${username}";
  gitEmail = "mrsosedik@gmail.com";

  # System settings
  sysTimezone = "Europe/Kyiv";
  sysLocale = "en_US.UTF-8"; # System locale
  sysExtraLocale = "uk_UA.UTF-8"; # Time/date/currency/etc. locale

  # System hardware
  cpuType = "amd";
  gpuType = "amd";

  # Enable NTP
  ntp = true;

  # Enable Printer & Scanner Support
  printer = false;

  # Enable apps
  flatpak = true;
}
