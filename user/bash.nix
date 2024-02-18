{ config, lib, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) flakeDir shell; in
lib.mkIf (shell == "bash") {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      neofetch
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
    '';
  };
}
