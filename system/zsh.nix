{ lib, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) shell; in
lib.mkIf (shell == "zsh") {
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # Enable auto completion of system packages for home-manager
  environment.pathsToLink = [ "/share/zsh" ];
}
