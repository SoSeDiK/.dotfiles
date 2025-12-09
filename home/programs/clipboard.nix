{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    xclip
  ];

  services.copyq = {
    enable = true;
    forceXWayland = false;
  };
}
