{ ... }:

{
  sops = {
    age.keyFile = "/persist/etc/sops-keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
  };
}
