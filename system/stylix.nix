{ pkgs, profileName, ... }:

let
  inherit (import ../profiles/${profileName}/options.nix) theme;
  # (!) Note: GDM's cursor is handled separately, and should be changed alongside!
  cursorName = "Bibata-Modern-Ice";
  hyprCursorPath = ./profile/Bibata-Modern-Ice.tar.gz;
in
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

    polarity = "dark";
    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    };

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
