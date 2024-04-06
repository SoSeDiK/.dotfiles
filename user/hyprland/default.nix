{ inputs, config, pkgs, profileName, ... }:

let
  theme = config.colorScheme.palette;
  inherit (import ../../profiles/${profileName}/options.nix) flakeDir;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./ags/ags.nix # task bar and many other things
    ./cursor
    ./rofi # app/task launcher
    ./cliphist/cliphist.nix # clipboard history
    ./emoji-picker/rofimoji.nix # emoji picker
    ./misc/monitors.nix # monitors managements
    ./misc/screenshots.nix # screenshots
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./hypr/hyprland.conf);
    plugins = [
      #
    ];
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # Generate some dynamic options
  home.file."${flakeDir}/user/hyprland/hypr/generated.conf".text = ''
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
}
