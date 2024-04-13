{ inputs, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) flakeDir; in
{
  environment.systemPackages = [
    inputs.nh.packages.${pkgs.system}.default
  ];

  imports = [
    inputs.nh.nixosModules.default
  ];

  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
  };

  environment.variables = {
    FLAKE = "${flakeDir}";
  };
}
