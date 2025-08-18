{ inputs', config, flakeDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home.packages = [
    inputs'.quickshell.packages.default
  ];

  xdg.configFile."quickshell/shell.qml".source = mkOutOfStoreSymlink "${flakeDir}/assets/quickshell/shell.qml";
}
