{ inputs, config, pkgs, username, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../../apps/terminal/kitty.nix    # terminal
    ./ags/ags.nix                    # task bar and many other things
    ./rofi/rofi.nix                  # app/task launcher
    ./cliphist/cliphist.nix          # clipboard history
    ./screenshots/satty.nix          # screenshots
    ./emoji-picker/rofimoji.nix      # emoji picker
    ./misc/monitors.nix              # monitors managements
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./hypr/hyprland.conf);
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
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
    # Non-libs
    pyprland # "app overlays"
  ];

  # Pyprland config file
  home.file."/home/${username}/.config/hypr/pyprland.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/wm/hyprland/hypr/extra/pyprland.toml";
}
