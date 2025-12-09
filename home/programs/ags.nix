{ inputs', inputs, config, flakeDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    package = inputs'.ags.packages.agsFull;
    configDir = mkOutOfStoreSymlink "${flakeDir}/assets/ags";
    extraPackages = with inputs'.ags.packages; [
      apps
      battery
      bluetooth
      cava
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
