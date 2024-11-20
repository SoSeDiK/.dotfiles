{ inputs', config, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home.packages = [
    inputs'.quickshell.packages.default
  ];

  xdg.configFile."quickshell/shell.qml".source = mkOutOfStoreSymlink "${dotAssetsDir}/quickshell/shell.qml";
}
