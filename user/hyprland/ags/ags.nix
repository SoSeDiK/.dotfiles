{ inputs, config, pkgs, profileName, ... }:

let inherit (import ../../../profiles/${profileName}/options.nix) flakeDir; in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with pkgs; [
    (python311.withPackages (p: [ p.python-pam ]))
    sassc
    inotify-tools
  ];

  programs.ags = {
    enable = true;
    configDir = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/hyprland/ags/config";
    extraPackages = [ pkgs.libsoup_3 ];
  };
}
