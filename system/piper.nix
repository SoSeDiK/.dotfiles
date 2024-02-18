{ config, lib, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) piper username; in
lib.mkIf (piper == true) {
  services.ratbagd.enable = true;
  environment.systemPackages = with pkgs; [
    piper
  ];
  users.users.${username} = {
    extraGroups = [ "games" ];
  };
}
