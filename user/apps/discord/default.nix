{ config, pkgs, ... }:

{
  imports = [
    ./krisp.nix # https://github.com/NixOS/nixpkgs/issues/195512
  ];

  home.packages = with pkgs; [
    vesktop
  ];

  programs.discord = {
    enable = false;
    wrapDiscord = false;
  };
}
