{
  lib,
  inputs,
  inputs',
  pkgs,
  flakeDir,
  hostName,
  homeUsers,
  ...
}:

let
  hyprland = inputs'.hyprland.packages.hyprland;
  hyprland-portal = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;

  plugins = true;
  hyprbars = true;
  hyprexpo = true;
  hyprwinwrap = true;
  hypr-dynamic-cursors = true;
  hyprsplit = true;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    libnotify
    libsecret
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
    withUWSM = true;
    package = hyprland;
    # package = hyprland.overrideAttrs (_finalAttrs: previousAttrs: {
    #   patches = previousAttrs.patches ++ [
    #     # ./patches/patch1.patch
    #   ];
    # });
    portalPackage = hyprland-portal;
    extraConfig = ''
      # Base config
      source = ${flakeDir}/hosts/${hostName}/assets/hypr/hyprland.conf

      # Some dynamic values
      source = ~/.config/hypr/generated.conf
    ''
    + (if plugins then "\n\n# Plugins" else "")
    + (
      if plugins && hyprbars then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprbars.conf"
      else
        ""
    )
    + (
      if plugins && hyprexpo then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprexpo.conf"
      else
        ""
    )
    + (
      if plugins && hyprwinwrap then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprwinwrap.conf"
      else
        ""
    )
    + (
      if plugins && hypr-dynamic-cursors then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprdynamiccursors.conf"
      else
        ""
    )
    + (
      if plugins && hyprsplit then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprsplit.conf"
      else
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/nohyprsplit.conf"
    );
    plugins =
      [ ]
      ++ (if plugins && hyprbars then [ inputs'.hyprland-plugins.packages.hyprbars ] else [ ])
      ++ (if plugins && hyprexpo then [ inputs'.hyprland-plugins.packages.hyprexpo ] else [ ])
      ++ (if plugins && hyprwinwrap then [ inputs'.hyprland-plugins.packages.hyprwinwrap ] else [ ])
      ++ (
        if plugins && hypr-dynamic-cursors then
          [ inputs'.hypr-dynamic-cursors.packages.hypr-dynamic-cursors ]
        else
          [ ]
      )
      ++ (if plugins && hyprsplit then [ inputs'.hyprsplit.packages.hyprsplit ] else [ ]);
  };

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/hypr/xdph.conf".source = "${flakeDir}/hosts/${hostName}/assets/hypr/xdph.conf";
      ".config/hypr/hyprlandd.conf".text = ''
        # Base config
        source = ${flakeDir}/hosts/${hostName}/assets/hypr/hyprlandd.conf

        # Some dynamic values
        source = ~/.config/hypr/generated.conf

        # Plugins
        source = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/nohyprsplit.conf
      '';
      ".config/uwsm/env".text = ''
        # Use the Ozone Wayland support in Chromium and Electron apps
        export NIXOS_OZONE_WL=1

        # Toolkit Backend Variables
        export GDK_BACKEND=wayland,x11,*
        export QT_QPA_PLATFORM=wayland;xcb
        export SDL_VIDEODRIVER=wayland
        export CLUTTER_BACKEND=wayland
      '';
    };
  });

  # Setup cache
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
