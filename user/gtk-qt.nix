{ pkgs, config, ... }:

let
  cfg = config.stylix;
in
{
  # Theme GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # https://github.com/diniamo/niqs/blob/main/home/style/qt.nix
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
  };
  xdg.configFile = {
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      custom_palette=true
      color_scheme_path=${config.xdg.configHome}/qt5ct/colors/default.conf
      style=kvantum

      [Fonts]
      general="${cfg.fonts.sansSerif.name},${toString cfg.fonts.sizes.applications},-1,5,50,0,0,0,0,0,Regular"
      fixed="${cfg.fonts.monospace.name},${toString cfg.fonts.sizes.applications},-1,5,50,0,0,0,0,0,Regular"
    '';

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=default
    '';
  };
  home.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    DISABLE_QT5_COMPAT = "0";
  };
}
