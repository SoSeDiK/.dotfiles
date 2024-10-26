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

  # Theme QT # TODO Doesn't work :')
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
    style.package = with pkgs; [
      kdePackages.breeze
      kdePackages.qtstyleplugin-kvantum
    ];
  };
}
