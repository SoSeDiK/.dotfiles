{
  self',
  lib,
  ...
}:

let
  hyprcursorName = "Bibata-Modern-Ice-Hyprcursor";
  hyprcursorPackage = self'.packages.bibata-hyprcursors-modern-ice;
in
{
  stylix.targets.vscode.enable = false;
  stylix.targets.firefox.enable = false;
  stylix.targets.starship.enable = false;

  # Prevent "module "kvantum" is not installed" when launching apps
  home.sessionVariables.QT_STYLE_OVERRIDE = lib.mkForce "";

  xdg.dataFile."icons/${hyprcursorName}".source =
    "${hyprcursorPackage}/share/icons/${hyprcursorName}";
}
