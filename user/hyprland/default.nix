{ inputs, config, pkgs, profileName, ... }:

let
  inherit (import ../../profiles/${profileName}/options.nix) flakeDir;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./ags/ags.nix # task bar and many other things
    ./rofi # app/task launcher
    ./cliphist/cliphist.nix # clipboard history
    ./emoji-picker/rofimoji.nix # emoji picker
    ./misc/monitors.nix # monitors managements
    ./misc/screenshots.nix # screenshots
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # package = (inputs.hyprland.packages.${pkgs.system}.hyprland).overrideAttrs (_finalAttrs: previousAttrs: {
    #   patches = previousAttrs.patches ++ [
    #     # ../../system/hyprland/patches/patch1.patch
    #   ];
    # });
    extraConfig = ''
      source = ${flakeDir}/user/hyprland/hypr/hyprland.conf
    '';
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
      inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
      # inputs.hyprspace.packages.${pkgs.system}.Hyprspace
    ];

    systemd = {
      variables = [ "--all" ];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # Generate some dynamic options
  xdg.configFile."hypr/generated.conf".text =
    let
      theme = config.lib.stylix.colors;
    in
    ''
      # Auto Generated
      # env = AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0

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
    source = ${flakeDir}/user/hyprland/hypr/hyprlandd.conf
  '';
}
