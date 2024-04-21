{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./sops.nix
  ];

  home.packages = with pkgs; [
    sops
  ];

  # TODO does this even work?
  sops = {
    defaultSymlinkPath = "/run/secrets"; # /run/user/1000/secrets
    defaultSecretsMountPoint = "/run/secrets.d";
  };

  sops.secrets.nixAccessTokens = { };
}
