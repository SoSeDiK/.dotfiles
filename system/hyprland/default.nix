{ inputs, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libnotify
    libsecret
    hyprland-protocols
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    handlr-regex # xdg-open replacement; handle URLs/files apps
    (writeShellScriptBin "xdg-open" "handlr open \"$@\"") # Proxy xdg-open to handlr
    (writeShellScriptBin "xterm" "handlr launch x-scheme-handler/terminal -- \"$@\"") # Proxy xterm to handlr
    gvfs
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # Used for file picker
    ];
    xdgOpenUsePortal = true;
  };

  # Fix apps running through xdg-open not being able to open links/apps
  # TODO waiting on https://github.com/NixOS/nixpkgs/pull/298896
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:/run/wrappers/bin"
  '';

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland = {
      enable = true;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
