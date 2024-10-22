{ inputs, pkgs, self, ... }:

let
  theme = "da-one-sea";
  cursorName = "Bibata-Modern-Ice";
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

    polarity = "dark";
    image = "${self}/assets/wallpaper.png";

    cursor = {
      size = 24;
      name = cursorName;
      package = pkgs.bibata-cursors;
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
