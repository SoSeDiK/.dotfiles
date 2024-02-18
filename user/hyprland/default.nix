{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./ags/ags.nix # task bar and many other things
    ./rofi/rofi.nix # app/task launcher
    ./cliphist/cliphist.nix # clipboard history
    ./screenshots/satty.nix # screenshots
    ./emoji-picker/rofimoji.nix # emoji picker
    ./misc/monitors.nix # monitors managements
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./hypr/hyprland.conf);
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
  };

  home.packages = with pkgs; [
    # Libs
    hyprland-protocols
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    gvfs
  ];
}
