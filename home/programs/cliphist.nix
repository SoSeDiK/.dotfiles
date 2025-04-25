{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard # dependency
    xclip # WINE compat
    cliphist
  ];

  services.copyq.enable = true;
}
