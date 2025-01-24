{ inputs, inputs', config, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs'.hyprland.packages.hyprland;
    # package = (inputs'.hyprland.packages.hyprland).overrideAttrs (_finalAttrs: previousAttrs: {
    #   patches = previousAttrs.patches ++ [
    #     # ../../system/hyprland/patches/patch1.patch
    #   ];
    # });
    extraConfig = ''
      source = ${dotAssetsDir}/hypr/hyprland.conf
    '';
    plugins = [
      # inputs'.hyprland-plugins.packages.hyprbars
      # inputs'.hyprland-plugins.packages.hyprexpo
      # inputs'.hypr-dynamic-cursors.packages.hypr-dynamic-cursors
      # inputs'.hyprsplit.packages.hyprsplit
    ];

    systemd = {
      variables = [ "--all" ];
    };
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  xdg.configFile."hypr/xdph.conf".source = mkOutOfStoreSymlink "${dotAssetsDir}/hypr/xdph.conf";

  # Generate some dynamic options
  xdg.configFile."hypr/generated.conf".text =
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

  # Separate config for dev environment
  xdg.configFile."hypr/hyprlandd.conf".text = ''
    source = ${dotAssetsDir}/hypr/hyprlandd.conf
  '';
}
