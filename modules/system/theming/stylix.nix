{
  inputs,
  pkgs,
  self,
  self',
  ...
}:

let
  theme = "da-one-sea";
  cursorName = "Bibata-Modern-Ice";
  hyprcursorPackage = self'.packages.bibata-hyprcursors-modern-ice;
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
      package = hyprcursorPackage;
    };

    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
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
