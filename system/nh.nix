{ config, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) flakeDir; in
{
  # https://github.com/viperML/nh
  environment.systemPackages = with pkgs; [
    nh
  ];

  environment.variables = {
    FLAKE = "${flakeDir}";
  };
}
