{ pkgs, ... }:

{
  # Keeping passwords / sessions
  services.gnome.gnome-keyring.enable = true;

  # Keyring data visualizer
  programs.seahorse.enable = true;

  # Storing app settings
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    dconf-editor
  ];
}
