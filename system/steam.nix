{ config, pkgs, lib, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) steam; in
lib.mkIf (steam == true) {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
