{ config, pkgs, lib, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) openrazer username; in
lib.mkIf (openrazer == true) {
  environment.systemPackages = with pkgs; [
    openrazer-daemon
    polychromatic # Front-end control
  ];

  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ username ];
}
