{ config, ... }:

let
  username = "sosedik";
in
{
  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
  };

  # Provide github token to not get API rate limit
  nix.extraOptions = ''
    !include ${config.sops.secrets.nixAccessTokens.path}
  '';
}
