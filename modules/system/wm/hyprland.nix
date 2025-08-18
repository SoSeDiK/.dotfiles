{
  lib,
  inputs,
  inputs',
  pkgs,
  flakeDir,
  hostName,
  homeUsers,
  withPlugins,
  hyprbars,
  hyprexpo,
  hyprwinwrap,
  hypr-dynamic-cursors,
  hyprsplit,
  hyprgrass,
  ...
}:

let
  hyprland = inputs'.hyprland.packages.hyprland;
  hyprland-portal = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
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
    + (if withPlugins then "\n\n# Plugins" else "")
    + (
      if withPlugins && hyprbars then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprbars.conf"
      else
        ""
    )
    + (
      if withPlugins && hyprexpo then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprexpo.conf"
      else
        ""
    )
    + (
      if withPlugins && hyprwinwrap then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprwinwrap.conf"
      else
        ""
    )
    + (
      if withPlugins && hypr-dynamic-cursors then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprdynamiccursors.conf"
      else
        ""
    )
    + (
      if withPlugins && hyprsplit then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprsplit.conf"
      else
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/nohyprsplit.conf"
    )
    + (
      if withPlugins && hyprgrass then
        "\nsource = ${flakeDir}/hosts/${hostName}/assets/hypr/plugins/hyprgrass.conf"
      else
        ""
    );
    plugins =
      [ ]
      ++ (if withPlugins && hyprbars then [ inputs'.hyprland-plugins.packages.hyprbars ] else [ ])
      ++ (if withPlugins && hyprexpo then [ inputs'.hyprland-plugins.packages.hyprexpo ] else [ ])
      ++ (if withPlugins && hyprwinwrap then [ inputs'.hyprland-plugins.packages.hyprwinwrap ] else [ ])
      ++ (
        if withPlugins && hypr-dynamic-cursors then
          [ inputs'.hypr-dynamic-cursors.packages.hypr-dynamic-cursors ]
        else
          [ ]
      )
      ++ (if withPlugins && hyprsplit then [ inputs'.hyprsplit.packages.hyprsplit ] else [ ])
      ++ (
        if withPlugins && hyprgrass then
          [
            inputs'.hyprgrass.packages.default
            inputs'.hyprgrass.packages.hyprgrass-pulse
          ]
        else
          [ ]
      );
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
