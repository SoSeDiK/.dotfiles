{ inputs, config, pkgs, ... }:

{
  imports = [
    ./libs/wayland.nix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services.xserver.desktopManager.gnome.enable = true;
}
