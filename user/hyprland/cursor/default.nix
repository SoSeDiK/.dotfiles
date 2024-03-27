{ pkgs, config, gtkThemeFromScheme, ... }:

let
  # (!) Note: GDM's cursor is handled separately, and should be changed alongside!
  cursorName = "Bibata-Modern-Ice";
  hyprCursorPath = ./Bibata-Modern-Ice.tar.gz;
  cursorPackage = (pkgs.bibata-cursors).overrideAttrs (oldAttrs: {
    installPhase = oldAttrs.installPhase + ''
      tar -xvf ${hyprCursorPath} -C $out/share/icons
    '';
  });
  cursorSize = 24;
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
    "org/gnome/desktop/interface" = {
      cursor-theme = cursorName;
    };
  };

  # home.sessionVariables = {
  #   HYPRCURSOR_SIZE = cursorSize;
  #   HYPRCURSOR_THEME = cursorName;
  # };
}
