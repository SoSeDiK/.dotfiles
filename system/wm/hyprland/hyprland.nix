{
  config,
  lib,
  homeUsers,
  ...
}:

{
  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
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
      ".config/uwsm/env-hyprland".text = ''
        # Prefer iGPU
        export AQ_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0
      '';
    };
  });
}
