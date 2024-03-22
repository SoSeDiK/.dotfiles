let
  # (!) Make sure to change on new setup!
  name = "SoSeDiK";
  username = "sosedik";
  hostname = "lappytoppy";
in
{
  # User variables
  name = "${name}";
  username = "${username}";
  hostname = "${hostname}";

  # Options
  theme = "da-one-sea"; # "atelier-cave"; # https://github.com/tinted-theming/home
  shell = "zsh"; # bash/zsh

  homeDir = "/home/${username}";
  flakeDir = "/home/${username}/.dotfiles";

  # Git
  gitUsername = "${name}";
  gitEmail = "mrsosedik@gmail.com";

  # System settings
  sysTimezone = "Europe/Kyiv";
  sysLocale = "en_US.UTF-8"; # System locale
  sysExtraLocale = "uk_UA.UTF-8"; # Time/date/currency/etc. locale

  # System hardware
  cpuType = "amd"; # System's CPU (either "amd" or "intel")
  gpuType = "amd"; # System's GPU (either "amd" or "nvidia")
  vfioIds = [ "10de:1f95" "10de:10fa" ]; # The IOMMU ids for GPU passthrough

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
