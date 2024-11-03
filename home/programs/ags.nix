{ inputs, config, pkgs, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with pkgs; [
    # Building dependencies
    which
    cage
    bun
    dart-sass
  ];

  programs.ags = {
    enable = true;
    configDir = mkOutOfStoreSymlink "${dotAssetsDir}/ags";
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk_4_0
      accountsservice
    ];
  };
}
