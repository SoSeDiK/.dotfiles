{
  inputs',
  config,
  flakeDir,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home.packages = [
    inputs'.quickshell.packages.default
  ];

  xdg.configFile."quickshell".source = mkOutOfStoreSymlink "${flakeDir}/assets/quickshell";
}
