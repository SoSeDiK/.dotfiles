{ inputs, pkgs, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with pkgs; [
    (python311.withPackages (p: [ p.python-pam ]))
    sassc
    inotify-tools
  ];

  programs.ags = {
    enable = true;
    configDir = ./config;
    extraPackages = [ pkgs.libsoup_3 ];
  };
}
