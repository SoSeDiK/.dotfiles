{ pkgs, lib, ... }:

let
  catppuccinAccent = "Blue";
  catppuccinFlavor = "Macchiato";

  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    accent = "${lib.toLower catppuccinAccent}";
    variant = "${lib.toLower catppuccinFlavor}";
  };

  qtThemeName = "catppuccin-${lib.toLower catppuccinFlavor}-${lib.toLower catppuccinAccent}";
in
{
  home.packages = [
    catppuccinKvantum
  ];


  # Theme GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    # GTK theme is handled by stylix
  };

  # Theme QT
  # Doesn't work on its own everywhere, needs system module too
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/${qtThemeName}".source = "${catppuccinKvantum}/share/Kvantum/${qtThemeName}";
    "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.theme = qtThemeName;
    };
  };
}
