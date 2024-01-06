{ config, inputs, pkgs, username, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with pkgs; [
    (python311.withPackages (p: [ p.python-pam ]))
    sassc
    inotify-tools
  ];

  programs.ags = {
    enable = true;
    #configDir = ./config;
    configDir = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/wm/hyprland/ags/config";
    extraPackages = [ pkgs.libsoup_3 ];
  };
}
