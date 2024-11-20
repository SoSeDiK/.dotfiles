{ inputs', inputs, config, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    package = inputs'.ags.packages.agsFull;
    configDir = mkOutOfStoreSymlink "${dotAssetsDir}/ags";
    extraPackages = with inputs'.ags.packages; [
      apps
      battery
      bluetooth
      # cava # TODO broken build, #355948
      hyprland
      mpris
      network
      notifd
      powerprofiles
      tray
      wireplumber
    ];
  };
}
