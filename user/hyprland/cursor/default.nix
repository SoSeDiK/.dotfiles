{ pkgs, config, gtkThemeFromScheme, ... }:

let
  cursorSize = 24;
  cursorName = "Bibata-Modern-Ice";
  hyprCursorPath = ./Bibata-Modern-Ice.tar.gz;
  cursorPackage = (pkgs.bibata-cursors).overrideAttrs (oldAttrs: {
    installPhase = oldAttrs.installPhase + ''
      tar -xvf ${hyprCursorPath} -C $out/share/icons
    '';
  });
in
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = cursorPackage;
    name = cursorName;
    size = cursorSize;
  };

  dconf.settings = {
    "/org/gnome/desktop/interface" = { cursor-theme = cursorName; };
  };

  home.sessionVariables = {
    HYPRCURSOR_SIZE = cursorSize;
    HYPRCURSOR_THEME = cursorName;
  };
}
