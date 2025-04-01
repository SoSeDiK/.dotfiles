{
  config,
  inputs,
  pkgs,
  ...
}:

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
  # gpg --import /path/to/the/key.asc, will ask for the passphrase
  sops.secrets.gitSigningKey = {
    mode = "0400";
    path = "${config.home.homeDirectory}/.gnupg/keys/git-signing-key.asc";
  };
}
