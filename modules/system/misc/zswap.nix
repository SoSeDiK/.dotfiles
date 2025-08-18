{ ... }:

{
  # Enable zswap
  # https://github.com/NixOS/nixpkgs/issues/119244
  boot.kernelParams = [
    "zswap.enabled=1"
  ];
}
