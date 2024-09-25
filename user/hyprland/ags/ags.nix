{ inputs, config, pkgs, self, ... }:

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
    # Utils
    hyprpicker
  ];

  programs.ags = {
    enable = true;
    configDir = config.lib.file.mkOutOfStoreSymlink "${self}/user/hyprland/ags/config";
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
}
