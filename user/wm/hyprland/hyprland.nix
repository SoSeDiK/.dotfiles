{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../../apps/terminal/kitty.nix    # terminal
    ./ags/ags.nix                    # task bar and many other things
    ./rofi/rofi.nix                  # app/task launcher
    ./cliphist/cliphist.nix          # clipboard history
    ./screenshots/hyprshot.nix       # screenshots
    ./screenshots/satty.nix          # screenshots
    ./emoji-picker/rofimoji.nix      # emoji picker
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./hypr/hyprland.conf);
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
