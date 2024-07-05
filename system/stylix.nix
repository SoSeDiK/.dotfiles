{ pkgs, profileName, ... }:

let
  inherit (import ../profiles/${profileName}/options.nix) theme;
  cursorName = "Bibata-Modern-Ice";
  hyprCursorPath = ./profile/Bibata-Modern-Ice.tar.gz;
in
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

    polarity = "dark";
    image = ../user/assets/wallpaper.png;

    cursor = {
      size = 24;
      name = cursorName;
      package = (pkgs.bibata-cursors).overrideAttrs (oldAttrs: {
        installPhase = oldAttrs.installPhase + ''
          tar -xvf ${hyprCursorPath} -C $out/share/icons/${cursorName}
        '';
      });
    };

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };

    targets.plymouth.enable = false;
  };
}
