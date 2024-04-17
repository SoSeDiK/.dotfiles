{ inputs, config, pkgs, ... }:

let
  inherit (import ./options.nix) homeDir;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
  ];

  sops = {
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
  };

  # Provide github token to not get API rate limit
  nix.extraOptions = ''
    !include ${config.sops.secrets.nixAccessTokens.path}
  '';

  # Actual secrets
  sops.secrets.nixAccessTokens = {
    mode = "0440";
    group = config.users.groups.keys.name;
  };
  sops.secrets.tailscaleAuthKey = { };
}
