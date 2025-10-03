{ config, ... }:

{
  sops = {
    age.keyFile = "/persist/etc/sops-keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
  };

  # Provide github token to not get API rate limit
  nix.extraOptions = ''
    !include ${config.sops.secrets.nixAccessTokens.path}
  '';
}
