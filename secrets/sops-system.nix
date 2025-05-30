{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./sops.nix
  ];

  environment.systemPackages = with pkgs; [
    sops
  ];

  # Actual secrets
  sops.secrets.nixAccessTokens = {
    mode = "0440";
    group = config.users.groups.keys.name;
  };
  sops.secrets.tailscaleAuthKey = { };
  sops.secrets."syncthing/gui-password" = { };
  sops.secrets."syncthing/certificate.pem" = { };
  sops.secrets."syncthing/key.pem" = { };
}
