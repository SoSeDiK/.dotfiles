{
  inputs,
  pkgs,
  self,
  ...
}:

let
  theme = "da-one-sea";
  cursorName = "Bibata-Modern-Ice";

  noto-fonts-color-emoji-plus = pkgs.callPackage "${self}/pkgs/fonts/rkbdi-noto-emoji-plus" { };
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
        package = pkgs.nerd-fonts.jetbrains-mono;
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
      emoji = {
        package = noto-fonts-color-emoji-plus;
        name = "Noto Color Emoji";
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

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Symbols Nerd Font Mono" ];
    sansSerif = [ "Symbols Nerd Font Mono" ];
    serif = [ "Symbols Nerd Font Mono" ];
    emoji = [ "Symbols Nerd Font Mono" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      noto-fonts-color-emoji = noto-fonts-color-emoji-plus;
    })
  ];
}
