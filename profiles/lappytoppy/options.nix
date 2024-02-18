let
  # (!) Make sure to change on new setup!
  name = "SoSeDiK";
  username = "sosedik";
  hostname = "lappytoppy";
  homeDir = "/home/${username}";
in
{
  # User variables
  name = "${name}";
  username = "${username}";
  hostname = "${hostname}";

  # Options
  theme = "atelier-cave";
  shell = "zsh"; # bash/zsh

  homeDir = "${homeDir}";
  flakeDir = "${homeDir}/.dotfiles";

  # Git
  gitUsername = "${name}";
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

  # Peripherals
  piper = false;
  openrazer = true;

  # Enable apps
  flatpak = true;
  steam = true;
}
