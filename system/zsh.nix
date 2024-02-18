{ config, lib, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) shell; in
lib.mkIf (shell == "zsh") {
  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
}
