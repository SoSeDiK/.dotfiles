{ config, pkgs, ... }:

{
  imports = [
    ./krisp.nix   # https://github.com/NixOS/nixpkgs/issues/195512
  ];

  programs.discord = {
    enable = true;
    wrapDiscord = true;
  };
}
