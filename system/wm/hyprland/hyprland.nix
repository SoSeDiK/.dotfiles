{ inputs, inputs', config, lib, pkgs, hmUsers, dotAssetsDir, ... }:

let
  hyprland = inputs'.hyprland.packages.hyprland;
  hyprland-portal = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
in {
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
    extraConfig = ''
      source = ${dotAssetsDir}/hypr/hyprland.conf
    '';
    plugins = [
      # inputs'.hyprland-plugins.packages.hyprbars
      # inputs'.hyprland-plugins.packages.hyprexpo
      # inputs'.hypr-dynamic-cursors.packages.hypr-dynamic-cursors
      inputs'.hyprsplit.packages.hyprsplit
    ];
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
      ".config/hypr/hyprlandd.conf".text =
        ''
          source = ${dotAssetsDir}/hypr/hyprlandd.conf
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
  };
}
