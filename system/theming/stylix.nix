{
  inputs,
  pkgs,
  self,
  ...
}:

let
  theme = "da-one-sea";
  cursorName = "Bibata-Modern-Ice";

  emoji-font-name = "Noto Color Emoji";
  emoji-font = pkgs.callPackage "${self}/pkgs/fonts/rkbdi-noto-emoji-plus" { };
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
      emoji = {
        package = emoji-font;
        name = emoji-font-name;
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

  # Extra font rules
  fonts.fontconfig.defaultFonts = {
    monospace = [ emoji-font-name "Symbols Nerd Font Mono" ];
    sansSerif = [ emoji-font-name "Symbols Nerd Font Mono" ];
    serif = [ emoji-font-name "Symbols Nerd Font Mono" ];
    emoji = [ "Symbols Nerd Font Mono" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      noto-fonts-color-emoji = emoji-font;
    })
  ];
}
