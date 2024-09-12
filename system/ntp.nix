###
# Network Time Protocol
###
{ lib, options, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) ntp; in
lib.mkIf (ntp == true) {
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
}
