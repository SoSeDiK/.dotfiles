{ pkgs, ... }:

{
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
  };

  # Theme QT # TODO Doesn't work :)
  qt = {
    enable = true;
    style.name = "breeze";
    style.package = pkgs.kdePackages.breeze;
    platformTheme.name = "qt5ct";
  };
}
