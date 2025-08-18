{ pkgs, ... }:

{
  # Keeping passwords / sessions
  services.gnome.gnome-keyring.enable = true;

  # Keyrind data visualizer
  programs.seahorse.enable = true;

  # Storing app settings
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    dconf-editor
  ];
}
