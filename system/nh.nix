{ config, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) flakeDir; in
{
  environment.systemPackages = with pkgs; [
    nh
  ];

  environment.variables = {
    FLAKE = "${flakeDir}";
  };
}
