{ inputs, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    libnotify
    libsecret
    inputs.hyprcursor.packages.${pkgs.system}.hyprcursor
    hyprland-protocols
    # KDE/Qt stuff
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    # ===
    handlr-regex # xdg-open replacement; handle URLs/files apps
    (makeDesktopItem {
      name = "handlr";
      desktopName = "handlr";
      exec = "${handlr-regex}/bin/handlr";
      mimeTypes = [ "x-scheme-handler/http" "x-scheme-handler/https" ];
      terminal = true;
    })
    (lib.hiPrio (writeShellScriptBin "xdg-open" "handlr open \"$@\"")) # Proxy xdg-open to handlr
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

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    package = (inputs.hyprland.packages.${pkgs.system}.hyprland).overrideAttrs (_finalAttrs: previousAttrs: {
      patches = previousAttrs.patches ++ [
        # ./patches/patch1.patch
      ];
    });
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland = {
      enable = true;
    };
  };

  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
