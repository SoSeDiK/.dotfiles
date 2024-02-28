{ inputs, config, pkgs, profileName, ... }:

let inherit (import ../../../profiles/${profileName}/options.nix) flakeDir; in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with pkgs; [
    # Building dependencies
    which
    cage
    bun
    dart-sass
    # Theme dependencies
    fd
    wf-recorder
    wl-clipboard
    gtk3
  ];

  programs.ags = {
    enable = true;
    configDir = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/hyprland/ags/config";
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
}
