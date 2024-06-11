{ pkgs, ... }:

let
  # (!) Note: GDM's cursor is handled separately, and should be changed alongside!
  cursorName = "Bibata-Modern-Ice";
  hyprCursorPath = ./profile/Bibata-Modern-Ice.tar.gz;
in
{
  stylix = {
    enable = true;
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

    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };
}
