{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./sops.nix
  ];

  home.packages = with pkgs; [
    sops
  ];

  sops = {
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };

  sops.secrets.nixAccessTokens = { };
}
