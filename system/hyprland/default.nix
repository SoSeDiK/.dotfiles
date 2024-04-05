{ inputs, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libnotify
    libsecret
    hyprland-protocols
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    gvfs
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # Used for file picker
    ];
  };

  # Fix apps running through xdg-desktop-portal-gtk (Flatpak/Steam's Proton) not being able to open links
  # For testing: NIXOS_XDG_OPEN_USE_PORTAL=1 xdg-open http://localhost
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
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
