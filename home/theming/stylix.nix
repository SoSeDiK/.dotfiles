{ pkgs, self, ... }:

let
  hyprcursorName = "Bibata-Modern-Ice-Hyprcursor";
  hyprcursorPackage = pkgs.callPackage "${self}/pkgs/bibata-hyprcursor" {
    variant = "modern";
    baseColor = "#FFFFFF";
    outlineColor = "#000000";
    watchBackgroundColor = "#FFFFFF";
    colorName = "ice";
  };
in
{
  stylix.targets.vscode.enable = false;
  stylix.targets.firefox.enable = false;
  stylix.targets.starship.enable = false;

  xdg.dataFile."icons/${hyprcursorName}".source =
    "${hyprcursorPackage}/share/icons/${hyprcursorName}";
}
