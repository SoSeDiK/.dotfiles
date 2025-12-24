{
  pkgs,
  self',
  lib,
  ...
}:

let
  cursorName = "Bibata-Modern-Ice";
  cursorPackage = pkgs.bibata-cursors;
  hyprcursorName = "Bibata-Modern-Ice-Hyprcursor";
  hyprcursorPackage = self'.packages.bibata-hyprcursors-modern-ice;
in
{
  stylix.targets.vscode.enable = false;
  stylix.targets.firefox.enable = false;
  stylix.targets.starship.enable = false;

  gtk.cursorTheme = {
    size = 24;
    name = cursorName;
    package = cursorPackage;
  };

  # Prevent "module "kvantum" is not installed" when launching apps
  home.sessionVariables.QT_STYLE_OVERRIDE = lib.mkForce "";

  xdg.dataFile."icons/${hyprcursorName}".source =
    "${hyprcursorPackage}/share/icons/${hyprcursorName}";
}
