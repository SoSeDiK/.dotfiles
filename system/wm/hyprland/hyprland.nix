{
  inputs,
  inputs',
  config,
  lib,
  pkgs,
  hmUsers,
  dotAssetsDir,
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
    package = hyprland;
    # package = hyprland.overrideAttrs (_finalAttrs: previousAttrs: {
    #   patches = previousAttrs.patches ++ [
    #     # ./patches/patch1.patch
    #   ];
    # });
    portalPackage = hyprland-portal;
    extraConfig =
      ''
        # Base config
        source = ${dotAssetsDir}/hypr/hyprland.conf

        # Some dynamic values
        source = ~/.config/hypr/generated.conf
      ''
      + (if plugins then "\n\n# Plugins" else "")
      + (if plugins && hyprbars then "\nsource = ${dotAssetsDir}/hypr/plugins/hyprbars.conf" else "")
      + (if plugins && hyprexpo then "\nsource = ${dotAssetsDir}/hypr/plugins/hyprexpo.conf" else "")
      + (
        if plugins && hyprwinwrap then "\nsource = ${dotAssetsDir}/hypr/plugins/hyprwinwrap.conf" else ""
      )
      + (
        if plugins && hypr-dynamic-cursors then
          "\nsource = ${dotAssetsDir}/hypr/plugins/hyprdynamiccursors.conf"
        else
          ""
      )
      + (
        if plugins && hyprsplit then
          "\nsource = ${dotAssetsDir}/hypr/plugins/hyprsplit.conf"
        else
          "\nsource = ${dotAssetsDir}/hypr/plugins/nohyprsplit.conf"
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

  hjem.users = lib.genAttrs hmUsers (username: {
    files = {
      ".config/hypr/xdph.conf".source = "${dotAssetsDir}/hypr/xdph.conf";
      ".config/hypr/generated.conf".text =
        let
          theme = config.lib.stylix.colors;
        in
        ''
          general {
            col.active_border = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg
            col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
          }

          group {
            col.border_active = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg
            col.border_inactive = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
            groupbar {
              col.active = rgba(${theme.base01}cc)
              col.inactive = rgba(${theme.base00}cc)
            }
          }
        '';
      ".config/hypr/hyprlandd.conf".text = ''
        # Base config
        source = ${dotAssetsDir}/hypr/hyprlandd.conf

        # Some dynamic values
        source = ~/.config/hypr/generated.conf

        # Plugins
        source = ${dotAssetsDir}/hypr/plugins/nohyprsplit.conf
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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # Prefer iGPU
    AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  };
}
