{ config, ... }:

let
  inherit (import ./options.nix) homeDir;
in
{
  sops = {
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
  };

  # Provide github token to not get API rate limit
  nix.extraOptions = ''
    !include ${config.sops.secrets.nixAccessTokens.path}
  '';
}
