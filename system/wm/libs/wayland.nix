{ config, pkgs, ... }:

{
  imports = [
    ./dbus.nix      # sharing options between apps
    ./keyring.nix   # keeping passwords / sessions
    ./pipewire.nix  # sound management
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [ wayland ];

  environment.sessionVariables = {
    #NIXOS_OZONE_WL = "1";
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
